import 'package:project/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ProfilePage();
          } else {
            return const LoginPage();
          }
        }
      );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectionPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/profile': (context) => const ProfilePage(),
        '/Products': (context) => ProductDetailsWidget()
      },
      title: "Apple Store Online",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  FilePickerResult? _image;
  Future<void> pickAnImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) {
        return;
      } else {
        setState(() {
          _image = result;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30.0),
                kIsWeb
                    ? _image == null
                        ? IconButton(
                            onPressed: () {
                              pickAnImage();
                            },
                            icon: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              pickAnImage();
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  MemoryImage(_image!.files.first.bytes!),
                            ),
                          )
                    : _image == null
                        ? IconButton(
                            onPressed: () {
                              pickAnImage();
                            },
                            icon: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              pickAnImage();
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  MemoryImage(_image!.files.first.bytes!),
                            ),
                          ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.email_outlined),
                      labelText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                  controller: emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.password_outlined),
                      labelText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                  controller: passwordController,
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: "Enter FullName",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                    ),
                  controller: fullnameController,
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.mobile_friendly),
                      labelText: "Enter Mobile",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                  controller: mobileNumberController,
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.location_city),
                      labelText: "Enter Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                    ),
                  controller: addressController,
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _handleSignUp();
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child("Users");
  final Reference profilrimageref = FirebaseStorage.instance
      .ref()
      .child("UserProfileImage/${DateTime.now().millisecondsSinceEpoch}.jpg");
  Future<void> _handleSignUp() async {
    UploadTask uploadtask = profilrimageref.putData(_image!.files.first.bytes!);

    String imgurl = await (await uploadtask).ref.getDownloadURL();
    Auth()
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .whenComplete(() {
      print("user created successfully!");
      Auth()._auth.authStateChanges().first;
      Future.delayed(const Duration(seconds: 3)).then((value) {
        try {
          UserDetails user = UserDetails(
              fullName: fullnameController.text,
              email: emailController.text,
              address: addressController.text,
              mobileNumber: mobileNumberController.text,
              profilePhoto: imgurl);
          if (Auth()._auth.currentUser != null) {
            print(Auth()._auth.currentUser!.uid);
            userRef
                .child(Auth()._auth.currentUser!.uid)
                .set(user.toMap())
                .then((value) {
              print("user added successfully to realtime database!");
              Navigator.pushNamed(context, "/profile");
            }).catchError((error) {
              print("Failed to add user to realtime database");
              print(error.toString());
            });
          } else {
            print("the user uid is still null !!");
          }
        } on FirebaseException catch (error) {
          print("error occured !!!");
          print(error.message);
        }
      }
    );
   }
  );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Apple Store Online",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARwAAACxCAMAAAAh3/JWAAAAdVBMVEX///8AAAD8/PwEBAQNDQ2JiYnX19fAwMCenp729vb5+fm4uLjv7+/U1NTl5eVxcXEeHh6mpqZiYmLJyclHR0dNTU2xsbFVVVVdXV3n5+cRERE8PDx8fHzd3d2EhISkpKQrKyuampo1NTWSkpIYGBgjIyNJSUnpiCFjAAAEO0lEQVR4nO3ci3KiMBQG4CTcRFFEFFS82+77P+ImQJEO1q3JsGEO/9dpp1PamfA3nEAIMAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4UQbMrYdJdGtlsyTCI9rTmf2W7GEIWJTIYjnGcCFY0jPwLbLRmc6MC/zG23ZWgWm7LbKO7CdmMG5liUB1SZzlrYbs2AyCzCTd1rlBNDOg+CxU02jio5CKcla+qN/LpBNG3RspUNBvLv7o+C4/DcdmuGRXWcJhv3aLs5w5K1Riqe2W7NwOT8kY6Hkeq7uhI78vPAEM43i7raOOXpn0A4DRlF0NTixHZrhierS07uq7nAUR5W1T53Dhr5g6zsONvg8VvjNY2Ovr+blt8LFY6/jb1sUQUTLtLsnAR+JNjokhLH86rYq45y2U78sPpZs3GRrC71iO4Wh2xnrZk2hLO8ufJWiuuxlUy2rTcq6pt9PI4ZQVVnRbDmHduszGcxi93uRs5jv1ulyJE7GMWcty8TvnqQm3vX1fJZMqr/LJMxjF/prRNN+whzeH0sdTYdQvLhBB9NZ/gpn6fktji03fgeqf97sH8RwCsquBPhniMr6nH5snu8TEf+4dn2LvRJ3VrQDofzG915U3lMeK/ryj/EEeWKPNcPRroTTkb+17cm2Vxtt79fqckx5RE+BVQ7ttINRhbxle0d6JWoJ0H1XEhfmMuec9YfxjnxaVPBNvol5xJObbe/T0KEuslwNVKRLcaKMDrJ8W03v2+JfjZ72h1H7p2nH05OPhyD0+O77db3bqMfDumZilKhHw71xSjCJJyEfM0xCGdiu/W9MwjnYLvtvTMoyGvbbe+d9oQF5+6Ues056YfDU9oVWbCJQTix7eb3LTAIZ096rqueCNSc0HHVBQTpA4uZ3LNyjsTTMbjydHhOeQGK3LGrwa1gh/pzaXOT21blNQThtV1T1ywddcuTbjork3DUkn/KL2+YGYWjHmtMbe9Cb0T0oZ9NLab7gFpsGI3sPHuqRVmkxj2HH4jWZCGEwYRX3XUI395LjJa9SYXtPeiNYNHNsOPQfZ+OrBYTg2UoMptbSLPisPKZqujTqOskZLMpTUyKzo3yKbIUPXma6NcyouN4TZjMlubEb0Kw8jRZsyjPKV+Vs+pZtIvWyY6jViITVz1a/344Dv9Ddxhv01rj5Y7lFVU5f6/zqN9NKE+SPgi2W74ZjjOml6K8uezW4Xk4mreiCDZ7L51iJ8Q4DqtSxh+PSDcvlPyp39zG9hbO4KNJp4qmiM+Bf5wH9+2yKjPO19cN7WUEHfII8Tetqnzz5s1D42I3W1WZVbyQkX4s5KnoXE99fcZBdbn9qCqLa/0mEHck7/jomqbXk3eeP33RgIjS5HoOiE9S/Gg0g4+OcnQWr05fxnJq89zrfae8JAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH7lL1BLJ9mGKMGLAAAAAElFTkSuQmCC"),
                ),
                const SizedBox(height: 20),
                const Text('Welcome To Apple Store !', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: _controllerEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _controllerPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  obscureText: true,
                ),
                const SizedBox(height: 10.0),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(height: 22.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSignin();
                    }
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 11.0),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/signup');
                  },
                   child: const Text("Don't have an account ?!  Sign Up"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignin() {
    Auth()
        .signInWithEmailAndPassword(
            email: _controllerEmail.text, password: _controllerPassword.text)
        .whenComplete(() {
      print("User Signed in Successfully !");
      Navigator.pushNamed(context, "/profile");
    });
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService fbs = FirebaseService();
  UserDetails? usr;
  late String imgurl;
  @override
  initState() {
    super.initState();
    fatchUserData();
  }

  Future<void> fatchUserData() async {
    try {
      UserDetails? us = await fbs.getUserFromDatabse();
      if (us != null) {
        setState(() {
          usr = us;
          imgurl = usr!.profilePhoto;
        });
      } else {
        print("user not found");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: usr == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(usr!.profilePhoto),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                      icon: Icons.person,
                      label: 'Full Name',
                      value: usr!.fullName),
                  _buildInfoCard(
                      icon: Icons.email,
                      label: 'Email Address',
                      value: usr!.email),
                  _buildInfoCard(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: usr!.address),
                  _buildInfoCard(
                      icon: Icons.phone,
                      label: 'Mobile Number',
                      value: usr!.mobileNumber),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: () {
                        addtodb();
                      },
                      child: Text("Add Data To FB")),
                      SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/Products");
                      },
                      child: Text("Go to Product List")),
                      SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: () {
                        Auth()._auth.signOut();
                        Navigator.pushNamed(context, "/");
                      },
                      child: const Text("Sign Out"))
                ],
              ),
            ),
    );
  }

  void addtodb() {
    final DatabaseReference dataref =
        FirebaseDatabase.instance.ref().child("Products");
    for (int i = 0; i < desc.length; i++) {
      PhoneSpec phone = PhoneSpec(
          desc: desc[i], name: names[i], picUrl: images[i], price: price[i]);
      dataref.push().set(phone.toMap()).then((value) {
        print("Products Details Added Sucessfully");
      });
    }
  }
}

Widget _buildInfoCard(
    {required IconData icon, required String label, required String value}) {
  return Card(
    elevation: 5,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class ProductDetailsWidget extends StatefulWidget {
  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  List<PhoneSpec>? products;
  @override
  initState() {
    super.initState();
    fatchProductDetails();
  }

  Future<void> fatchProductDetails() async {
    try {
      List<PhoneSpec>? ps = await FirebaseService().getProductDetails();
      if (ps != null) {
        setState(() {
          products = ps;
        });
      } else {
        print("Product Data not Found not found");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: products == null
          ? Center(
              child: Column(
              children: [
                Text("Still loading the product details"),
                CircularProgressIndicator()
              ],
            ))
          : ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            products![index].picUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width:8), 
                          Column(
                            children: [
                              Text(
                                products![index].name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              SizedBox(width:8),
                              Text(
                                'Price: ${products![index].price}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Clicked on Product ${products![index].name}");
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ProductDetailPage(
                          productImageUrl: products![index].picUrl,
                          productDescription: products![index].desc);
                    }));
                  },
                );
              },
            ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String productImageUrl;
  final String productDescription;

  ProductDetailPage(
      {required this.productImageUrl, required this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              productImageUrl,
              height: 350,
              width: 250,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                productDescription,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetails {
  String fullName;
  String email;
  String address;
  String mobileNumber;
  String profilePhoto;

  UserDetails({
    required this.fullName,
    required this.email,
    required this.address,
    required this.mobileNumber,
    required this.profilePhoto,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'address': address,
      'mobileNumber': mobileNumber,
      'profilePhoto': profilePhoto,
    };
  }

  factory UserDetails.fromMap(Map<dynamic, dynamic> map) {
    return UserDetails(
      fullName: map['fullName'],
      email: map['email'],
      address: map['address'],
      mobileNumber: map['mobileNumber'],
      profilePhoto: map['profilePhoto'],
    );
  }
}

class FirebaseService {
  User? user = Auth()._auth.currentUser;
  DatabaseReference userref = FirebaseDatabase.instance.ref().child("Users");
  Future<UserDetails?> getUserFromDatabse() async {
    try {
      if (user != null) {
        DatabaseEvent event = await userref.child(user!.uid).once();
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> snapMap = event.snapshot.value as dynamic;
          return UserDetails.fromMap(snapMap);
        } else {
          print("user details null");
          return null;
        }
      } else {
        print("the current user is null");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<PhoneSpec>> getProductDetails() async {
    DatabaseReference productsRef =
        FirebaseDatabase.instance.ref().child("Products");

    try {
      DatabaseEvent event = await productsRef.once();

      if (event.snapshot.value != null) {
        print(event.snapshot.value.toString());

        List<PhoneSpec> productList = [];
        Map<dynamic, dynamic> snapshotData = event.snapshot.value as dynamic;

        snapshotData.forEach((key, value) {
          productList.add(PhoneSpec.fromMap(value as Map<dynamic, dynamic>));
        });

        print("Product List: $productList");
        return productList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting product details: $e');
      return [];
    }
  }
}

class PhoneSpec {
  String desc;
  String name;
  String picUrl;
  String price;

  PhoneSpec(
      {required this.desc,
      required this.name,
      required this.picUrl,
      required this.price});

  Map<dynamic, dynamic> toMap() {
    return {
      'desc': desc,
      'name': name,
      'picUrl': picUrl,
      'price': price,
    };
  }

  factory PhoneSpec.fromMap(Map<dynamic, dynamic> map) {
    return PhoneSpec(
      desc: map['desc'],
      name: map['name'],
      picUrl: map['picUrl'],
      price: map['price'],
    );
  }
}
List<String> images = [
  "data:image/jpeg;base64,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",
  "data:image/jpeg;base64,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",
  "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBMUExgUEhUTGBQaGhgZGhgZGBgUGRgYGBgZGxsaGRobJC0kGx0qHxobJTcmKi4xNDQ0GiM6PzoyPi0zNDEBCwsLEA8QHRISHzEqIyozMzMzNjkzMzwzMzMzMzMzMzM2MzEzMzUzMzMzMzMzMzMzMzEzMzMzMzMzMzMzMzM8Mf/AABEIANgA6QMBIgACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAABQcCBAYDCAH/xABQEAACAQICBAkIBQcJBwUAAAABAgADEQQhBRIxUQYTIkFSYXGBkQcUMkJykqGyM2KxwdEIIzVzgqLwFRZEVJOj0uHjQ2Nkg8LT4hdTlLPx/8QAGQEBAAMBAQAAAAAAAAAAAAAAAAECAwQF/8QALhEAAgICAQIFAwIHAQAAAAAAAAECEQMxIRJRBBNBYZEycbGBoSJCUsHR4fEU/9oADAMBAAIRAxEAPwC5oiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIB+Tzeqq+kwHaQJzXlG01UwejqtaibVOSinol2A1u0C5HXafNyU2rvr1Kjs7HNmvUYnrJNzJjFt0gfWnnSdNPeEedU+mnvCfMmj+CqVKio1cqrap1uL1sj1a42Z8/NJ6t5L9RipxWzn4nb1jlzZ+GyL0M3litsv3zqn0094R5zT6a+8J8+/+mf8AxX9z/wCc9F8mF/6Wf7H/AFJR4pLaJU4vTL+86p9NPeEedU+mnvCUOvkqv/Sz/Yf6k9l8kV/6Yf8A4/8AqSnSy1l5ec0+mnvCPOafTX3hPnLhXwAbBU0qCvxisxU/m+L1SACPXN75+E5engRcazWW4udW9hfM2vnlzS3lyq6Fo+tfOqfTT3hHnVPpp7wny5wk4NHB4h6Jqa4W1n1dXWDKGBtrHmO+QNSmQSNtpDi1sWfYPnVPpp7wjzqn0094T481cthv2TJaZJAANyQBYE3vstvlST7B86p9NPeEedU+mnvCfJyaMvSqVA+aah1bbQ7at73ysSObnmlxHX8JZxa2RZ9fedU+mnvCPOafTT3hPkNcNfn+H+ckMDobjNbl2sL+je+Y65aGOUnSRDkls+rPOqfTT3hHnVPpp7wnz6fJuLKwxVwyq30PSUNb0+u3dM6Pkx1v6Vb/AJP/AJyZYZraKrLF6Zf/AJ1T6ae8I86p9NPeEour5JtVNfzw7QLcR9/GTW/9L/8Ai/7j/wA5TokW6kX75zT6ae8J+pXRjYMpO4EGUJT8lesbDF/3H+pMMX5Mmpqz08XrOgLKOKKXKi45Qcldm20OLWyU7PoSJXfkb4QVsVg3Su5d6LhQ7G7FGW6hifSIIYX3WliSpIiIgCIiAcB5av0U/wCspfNKCwrZCX75af0U/wCspfNPn+gchLwdMhnV6OxWsqsPTTb1qecdh+2WhoTGLiaSqSOMUWH1hu7RKUwWI1GB/gidPobTDYdwb61M7CTmOonfPXhJZYV6o5Zxp+xZTUSDYjOZok/dFaZo4pRrGz7+fv39skGwLDNbMN4nLkbTqSpkxjXKPGkk3qKzWRCNom3SnLI2iyM4T6MGIwr07cq2sntrmPEXHfKIxFAoxUjZPpApeVbw94OFHNamvJbM25jzzo8MlJOPrtFckqaZoacoed4HD4pc6iJxFTfrU/RJ6ylj3SH4E4k0sdSJyDk0z+3bUHVdwg7LyZ4E4pdZ8LUNqdYAAnYtQeg33HtkVpzRD0KzKQVN8iMiCNx++bvB1L3X4KLJUqLq4sMCDmrCx6wRn8JGcHMOfNXwdQnWpF8OTn6BF6bD/lunep3T14L6TGKw6VMte1qgHM621xbmFyGA6LrNytS4usKw9FwKdTsBJpufZJI7HJ5pwtNNpmy7lEtg2p18RhmFi4emF5g2T0x3Mir2znAZZ/lGwKccMZh2y4w06lhY06qNzg7OVyuvWY7BK/0vh9SprKLI92UdEk8tP2WuOzVPPLTjcVLsQnyaqGS+hX5er0gV8RlIZTNvC1NVgRzGThnUkxJWi4dBVuNwtJudQUbtQ3H7rL4SbwdKcTwN0gBVakTyawDp1VBfk992HaVlgYRZ0ZzliqkZ49OQg62P2TRWneSmkByF7T901sOvOebOcidI6jyq2Qao2nb+E0sT9G/sN8pntVe5JM18Sfzb+w3ymVomyC/J/wDocV7dL5Wluyovyf8A6HFe3S+VpbsyLiIiAIiIBwHlq/RT/rKXzT58pbBPoPy1fop/1lL5pTeN4K16eEo4xRr0KiBmZRnTa5FnHMuWTbN9ue0SGQyPJLB4q3JbNTtH8bDIoGZq81x5HB2irSfDOkw2KqUSHpsSm8bV6jO60Dw2U2FQ6p38x7d0q7CY0ods314upmp1G/dP4TvjkhkVSMnFx5ReuF01TqAE6rA84t9om8lem2y4+MoSlisRRN1LAdJTkfCS+D4aVlyfVbtGqfEZfCZz8Kv5WSpsutAOZgZ54vCJUQo4uDK1wnDxPXRx7JDfbaTuC4a0G/2gHtXX4nL4zJ+HyRdos5RkqZzPCHgw+Gqa6A6l7gjmk/SoJpPDarWGJQWvzsBsbt5p0tPSlGsmq+qyHnFiPESDxnB96T8fg3vY3sNo7ucTthnUo9MuJLT9H9/ucWSEo8rlfucpoLF1cDXZH5KsRrBrhdYXAY9ViQdwN8yolq4XF06tPWGam6sptdTzqw3/AAO0XBE596OH0imrUATEKM+bvG8fZIQJisC+q1ittVWYni6iDYjkej9V/V2G6+jlmhHLriS2u/2NceXpXPKfr/k8uGeEbCVWrMpqYKuAlYDlFDsVvaHMT6XKU+kZyGN0ProaQZWy4yjUBurpawcHacuQ425BiLqVE4eFj4Z2pVUavg3ur0atuNpawuUa/pCxupzVhYgjOa5FBEL4R3qYMNr2U/n8G59YK3NzG/JcZNnyjjFNfwyNnq0Vy6MjFXBDKbEHaCJmjTu9J6BXGKr0SgxNjq6l9TEKoueLvmGAzNM8tM8mX0eDqU2RijgqymxB2iYSXS/YvGVk7orEkgKDZ1OshvazDmvzX/CW9wY0yuKp6+youVRdlm6QG4/A3G6UTSqWNxOn0JpipTqLUpG1UZFTsqLzgjnP29s6oyU409+hnONO0Xk6a6FefaO0f5XmiFsrdk0tA8IqddNZMmHpIfSU/eOvxkrVIPKXYds5ZwlF0y8WmiBZ8544l/zb+y3ymbGMo2YyPxJsj+y32GSkGzQ/J/8AocV7dL5Wluyovyf/AKHFe3S+Vpbs5jUREQBERAOA8tP6Kf8AWUvmmnwOSoujMMycpTTzU5gi7XBE3PLT+in/AFlL5pwfBjhYaGGpJxVYBVtrIQytmcyjcn7+uaY9lJ3XBlwk4LYSrUPm1Snhq5z4lzq0nv0OdOwXX2ZwmkdGVsO+pXpujHZfNW60cXVxntUmWZi+E2j8Wupiqf7WoUYHq2gduuJH/wAkXUrgcclSkdtCsUZMuazhqZPdfrmzxp6KKXcrkGZpVInT6Q4OMudSi9E58pAzU/Biw8HA6pCVtE1B6DI46iFa3WGy8CZV45R5ospJmeG0iy7DNxcZTf00XtHJPwkHVpOnpqy9oI8Cds/Fcy8PESjwQ4JnQChRb0WZe3OZfyePVqL8RIBa5nsmKO+bLxS9UR5fZk5Rw1emb06ljvV9U+IMntG8KsfQPKHGL4H3l+8GcWuNbfPVNIsOeXfiISVNEeXLuWlheFmDxDDjg2Grcz21RfeSMu/IzqqbM6WbUqIR6Q5aMPrAZqesf5yil0q/Objrz+2bej9PvROtSZqZ+o2qO9DdD4SjcH9Lr7lfLaeiw9OcGaVSyDI25CMyq6jaRSc8l0z9Bss8iCbzjq2i6mEYl1camyumsjoDzVF2ouXrAqdl2k3g/KGHXi8XSp1UO26gHLqNwT15SRoaVwlS3m+LakealiQa1ME7dSpcOhN7cl7DdLRytPnn3I8utfBxiVXpnWpsgLWJUi1N9XNWKLkrA5h0II9ULtm/jMThcaAmLVqdfYtQlQ+Z6ZslZc/W1X9s5yZx3B1anK4lkvmXwjLXpt1tSsCO5C31pzOK0FVzWk9Kr9S/Fv30qtiPEmVnJP0LpdyE0rwer4e7ECpTH+0QGy+2p5VM9TASOpVSMwZOrjcThSARUp2uoV1fV6wmtZlHssAeueeIxGGrG9SnqOdr0rKCd5UC3ghP1pn0LcWWt+p6aO0uQwbWKVBsdf8Aq39ssDQnCzYtawvlrjNG7bbP4ylYtou/0NSm/wBU/m390kgd5HZMFqVqO1XUc9xdT3+iZr1uqmrRRx5tMvZmWot0II2ixv8A/okZjKfIf2W+Uyt9E8K3pnIld+rmp7VM66jwwo1abCpYMVbMZZ2PMf8AOZOC3F3+Ser+pHp+T/8AQ4r26XytLdlRfk//AEOK9ul8rS3ZxG4iIgCIiAcB5av0U/6yl80pjRy4bi0u2KR7cpkVGUneDxisB3S5/LT+in/WUvmlWaC0bTeih19ZytylKg9dxmfTLlUXuJl4K2Q3R4HU9XGX6qlGo3xCNMhhHbMPhH/YqUz8VEm/MaaDWYMqjI8ZVUZ9dPDpyT1GoJ5g09Xk0r/WKag/vmqse5ROiMZLRm2iOpY3FUTdSV9jE/YGaZNp92zq0lc87OlJyf2lAPxm1VxpQcinTUbPWQX/AGSqn3ZpYrGYgG7tSp9bJTptbeNYBmHWt5r1SS2vgikzzXSeFbLiWVjt4tqqnuuW+ww2CoPnqYsdbUlqeLaiMfGaVXSp2Nia7ewG1e/WKEdwM0WxSnZScn69QuO8KFPxmLmntFqJGpoih/7pX2qTIfnf7JqtopL8nE4fvaoD4cXb4zzprUb0KVNesJrfOWnscJU9d1Xs1Kfy2lo4pS0mQ5xW2eFTRTjZUw7dlamPg7AzVeiy7Snc6N8pMkPMqfrVQfEwMJQ6Z92W/wDLPsvkr5sSMuYDGSy4ah0z7s900ZTIuGy3kEDxheEyPVfIeeK3+CEDmZCoZKPhaY9cQtKnuduxQPiT90yeOSNLRp4fSNWmbpUqId6sV+yS6cMMZbVqOtVejVRKo/eF/jPaloipq65w6onTr1OLTuJ1L9xM/GNJMuMpE7qOHFXxfEWHgTHTJbYtHrS4aMBZ6FO2yyPVpLb2NZk/dgaQwtUHWwVW550RG/8AqWmT3meP8pNmKa1Tb/elF7SlBadveMxeviqgGS6vs8aD2PWL396Xj1PXJV0bDaNwr7ExadRRkXvutQ/Gfv8AJBXOniKgHRKXt3sy/LNOpQqLnVr8XuAbU/cW1+680K1SjztVqHryU97coeHjN7r6vyV3o28ThHB5VTDv1sra3fqKftmlWpAA5U9m1aqj4Ob/AAnnrr6lNR2kufHL7JtUsDWcHVTKx2KFGzfaZPnSLa2WR+T/APQ4r26XytLdlRfk/wD0OK9ul8rS3ZwmoiIgCIiAcB5af0U/6yl80qrBacqDDUqNJCTq2Jaz3JJySmBqntcMeyWr5af0U/6yl804DRWlqeGwFJkC0CyEPVAVq9VgTdaO72r5b12HTE+WUkatPR9fXBrkioRdUYGtXttuKYIFNfbZAJ44/TdOnddYu/Rpsr2z2PV1dTuRHO3liQWktNVKoKIOLpE3KKSWc9Kq+1z25bhItVvLvI9IjpRJYnTdZydQimNnIuGtuNRiXPZrW6po06BY5DM/GbeFwJbM5DeZ3PBvgZVrgORxVLpsLO3sg7PtmsMLaubpFZzS4XLONw2jMwDcsdigFmPYBnOp0XwNxNS1qaou9+U3ci/eZZuidA4TDC1NAzc7Hae07T4yZR9wA7BaaeZCH0xv3ZTplL6n8HBYTyei352pUfqB1F8Fz+MkU4G4SmPoaZ9oa58WvJ/TOn6GETWr1Ap5l2s3YNsrPTnDqvWuKI4qn0mIDHv2DsHjLQyZcnLdIOMVpcnQ6TGDw45YpLuUIpJ7FAvOC05pCjWYCnSVADtVQHbttkB4yNapxjevVcnmvme/Nj3Se0XwVxtbPVWgm0kizAb7bR3kTZ5FFcclFBvZBLSYZ6qoN7Wv8fum5gdE1K5vTFRxcDX9FM+bXewPYLnqnZ6J4K4YNdQK7L6VesfzKH6qeu24fGNM8L6FD83hLVao5JruOQu8U0W1x2aq7yxBEq5vVfoFTfHyRLcGqOGTjMW9tg1Kdgb7i72HdYNuBkfW07qC2Fp06I6dtd7e241vAIRMFoVsZUuhao4sGqueQlxfVuBZfYQd3PN3QvBWrXdRqsq7dY8lyuY1yRcUqZOS21nex1brrOtZ2uxpFJ7IApUquSxZ3yDO5LHlGyglthJ2AkX5rzoMDwVfkmoCt8wGUl2GV9WkLEDPa9tXnUidaaWEwKHUKDUuHrsoIQ+slFL5ucr57tdibA13wj4ZVK+tToa1OicmN71ao3u+RA+qLAbhsmEmlyy1tukSeksfhMLyPTqL6iFKjBhlyntqUzvCLeczjNPVqhOqRTXcl9c9rnlX7LDqkSiTfwWDaobKPwA3k80KUp8R4JpLlmulIseck7TtJPXvk1gNBO7AEG52KBrOe7mHWbToODnBxqmdPk0wbGqRmxG0Uwfm5vtsXRmhqdFeSthznazHezc80qOP6uX2K9Tlo5TQ3AtVAapZeoWZu9jkOxR3yerYanTpuKagchs9pPJO0nMyQxlYDL+BInF1fzb+y32GZSySkq0iVFIi/wAn/wChxXt0vlaW7Ki/J/8AocV7dL5WluzjNhERAEREA4Dy1fop/wBZS+afP5qMwXWYmyhRc31VGxRuGZy6zPoDy1fop/1lL5p8+0RkJaJDM0S8ltHaPLHZ/n1Ty0fhC7AeJ5gBtJllcDtDpbj3X82mSKfWbeftPcJ14Ma+p6X7mOSbSpbNvgzwVSmq1sSAzbUTmHWR9+09U6tsST2cwGQA6hI+piCxuZ6ioiI1So6pTQXZ2yAH3k7ANpmuRt8v/hhF3wiRo3P2k7ABvJ5pxvCbh8tPWpYHVdxk1dvo0O5B/tG+HbIXTnCGvj3OGwiOtDZqDkvUt61Yj0V+oP2jnaTegPJ6q6tTFkO3MmxF6gBt+ztmFpcs6YxOEwmAxWMqF1WpVcnlVX2DsvkNuz4TsNFeTu5DYl2c9FclHVc527AJYuGwVOmAqqABsAAAHYBPLS2lKWFpmpUNgNg52O4CVlmb4RKiiKXRuDwVM1GCIg3DlMd19rGcpjuED4lxTRSKbGyUl9J7Z3c7rC5vkAL9c5rT+n62Mqgtc3IWnTXO1zYADnYmWVwO4MrhaetVs+JcDXbaEXaKadQO0+sRuAA6Mc4411S5foZTg58J0iGraAxFcCnUfUoD0gm196rcclOa+1s72BsMqfk9w9Sops6oALqGsDtzLeln1EbMue3dV6oUKqqC7GyjmyzLH6oGZ7htImT1Ep0yzHkqLsecn8TkAOwCZz8RKXoWhjjHhEUujaNBVRUUIMkRRYE9YHNfxPfIThHp1aAaijBXzes4Nil1vqhumVtdvVWwA9ED805p80KLYp7cY5KUEOYDdK3OqDPrPbKi05jmP5sklideoSTdnY62q3XnrH6xA9QTTiC6p81pe/8AoyTlNuuF/Yw07pp8Sw9WkmSJsAG8jf8AZfnJJMaizFRPems5bc5W9nSkkqRsYLCl2CqMzO94KcHRXNjcYdDZ2GRrOM9RT0Rzn8RIXQGjGcpTTKpVvduhTGbse4HwMuDRWHSki06Y1UUaqjq3nrJzJ3mddeXHjbMJSt0b2FwiIAAAqqLAAWCqOYDdPKtUuSeYbB2TZxD6tPtNvvmgMw3YZyO3ybIhsSSSZq4lPzb+y32GbzpnPHEp+bf2W+UyUw0Q35P/ANDivbpfK0t2VF+T/wDQ4r26XytLdnOaCIiAIiIBwHlp/RT/AKyl80oLBpcCX75af0U/6yl80pDQtLW1f4z5ppiVyoh6Og0Vg/RTnfM+yDkO8j93rln1UFOmlJcgqi/tHM/h3Ti+DFIPiBuDBR2Ll91++d1i6Zao3tH7Z6Uqj0r9Tjlck2aTVUpo1SowWmguzHOw3ADMkmwAGZJAE5mnRxWlquV6eEpnIHYv1jbJqpHOMlBsvOx2uJfSVfi0YrgqLcpx677CV3k5hdwu3rC3dYZadNFp01CU1FlUfxmeuc2Sbbs1xwUVRhobQ9DCoEoqBvY+kx3yTBmqrzYVpzs2RjicStNWZiAqgkk7AALkyleEmnamNrEi/Fg2pp1byN5nV+VDTJVUwdM8upy3ttCA2Vf2mBP7HXOf0ZgOLCqoBquQovsUsQAPE5mTCFkSZNeT3g9Zji6ozUlKYPSGTv3ZoOvW3CWIrDaTYc53SNwyrTRaaeiihRvNuc9Z2nrJnhpnFHi1pqTrVWVMtoQkByOwEX6jL7ZGjdwFXXJrH18kHRpg5d7HlHq1d0zx+GNfVp3tTBDPvY8yj7e9Zgp5hkNgG4cwkXpLS5pYarVU8oI7Kesgin/0xTb4Fdyt+GellrY1yLGhhlKovqnUIW3YzlR2GcM7liSxJYkkk7SSbknvkhiG1aPW72/Zprc/F1P7MjhGaV0uwijNBJDR1DXqKu8iaCSc0Gti79FGI7bWHxl8EbkkRN0iweCOHAV61vTbi06qdO17e01vdM7PCvObwFPi6VJNmrTS/tMNdv3nMl8FVnTm5VnHCVzZK6Qfkp3/AHTUo1bGZ6Qa9NTuJHiB+EjlqTjS4Ouz3xNPVbqmriR+bf2G+UzcRw41TtGz8JqYsWpv7LfKZm+C65ID8n/6HFe3S+VpbsqL8n/6HFe3S+VpbsyLiIiAIleeULhjiNHuFRUCuqFGZCyk3cOusCBrCyG24zkKflXxx5qJ7KZ/xy3SRZ2nlmW+inH+8pfNKFw71ktqOotbmB2dqzvNN8OsRjKDYfEU0NN9UnVRlYFWDAg62WYE5Q0qA2pU8W/GEpJ2iLR54LTGNpG9OsqkfVU/apm7W4WaTcMGxIswINkpqbMLGxCAg57RNYU8N0Kni34z94vDdCp4t+Ms3N7YVL0PXBcKNI0aYpUsQq0xcgCnT2nrKXM9v55aV/rS/wBnS/wTV4rC9Cr4tP3isL0Kvi0fxdxaNocNNK/1pf7Ol/25l/PfS39bX+zpf9uanFYXoVfFo4rC9Cr4tI6WLRqYrSeLqVjXqVVaqbcoqvqgAWXVsMhzCetHTWNVg61lDKbg6iGxsRsK2557cVhehV8WjisL0Kvi0LqWmLR7/wA79Kf1pf7On/gnnU4U6RZkdsSpZCSh1KeRIKnLUscids9MNh8DqjjBX1+e2sB8J6+b6N3Yj9+Kl3Fow/nnpX+tL/Z0v8E08Tp7HVKZpVK4KGwK6iDIEEZhL7QJv+b6N3Yj9+PN9G7sR+/JqXcWjm6gqsFVmUhb2Gy2ta/N1Dwnn5u/SX+O6dNVw+j9U6oxGtbL0ts1Eo4WwutUm2Zuwud9pDTYtEKKL9Jf47psUa9dAQrqAwscgbi9+cST4rC9Cr4tHFYXoVfFpK6lphtMyfhPpEm5rrf2KfN+xMk4VaSGzEL7lP8AwTy4rC9Cr4tHFYXoVfFocpvbfyQlFehstwy0oV1Til1dtuLpc37E8hwp0l/WV9yn/gnlxWF6FXxafnF4boVPFpHPctwe44V6T/rK+5T/AMEyq8LtJsCGxKkEWP5unmNnQmrxeG6FTxb8YFLDnYlTxb8YabItFm+QWmVpYoG3p09nstLZnz5wc4W1MBTenhqYCu2uxemzsTYDbrDKw+JkpU8q+NHq0h202H/VI6WT1Iu+JVvArh/isbiVostMktc6tNgFQKxYs1yF2AAnnNueWlIaoWfhAM8MRhKdRSjojocirKGUjrByM2YkEkOvBjAAWGEwoHVRp/hNjA6GwtEk0KFCmW2lKaIT2lRnJCIBhxY3DwEcWNw8BM4gGHFjcPARxY3DwEziAYcWNw8BHFjcPATOIBhxY3DwEcWNw8BM4gGHFjcPARxY3DwEziAYcWNw8BHFjcPATOIBhxY3DwEcWNw8BM4gGHFjcPARxY3DwEziAYcWNw8BHFjcPATOIBhxY3DwEcWNw8BM4gGHFjcPATUxui8PXULXo0qig3AdFcA7wGE3ogEP/NnA2t5phbbuJp/hNzB6Oo0V1KNKnTS99VFVFvvsBtm5EAxVQNgAmURAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAP/2Q==" ,
  "data:image/jpeg;base64,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" ,
  "data:image/jpeg;base64,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"
];
List<String> names = ["iphone 15","ipad pro 12.9","MacBook Air M2","Apple AirPods (3rd)","Apple Watch ultra 2"];
List<String> desc = [
  "iPhone 15 Pro is the first iPhone to feature an aerospace‑grade titanium design, using the same alloy that spacecraft use for missions to Mars. Titanium has one of the best strength‑to‑weight ratios of any metal, making these our lightest Pro models ever. You’ll notice the difference the moment you pick one up. New contoured edges and the thinnest borders ever on iPhone make it even more comfortable to hold in your hand. The titanium band is bonded with a new internal aluminum frame through solid‑state diffusion. This is an industry‑first innovation, using a thermomechanical process that joins these two metals with incredible strength. The internal frame is also made from 100% recycled aluminum, which contributes to our overall usage of recycled materials and helps us work toward our 2030 climate goals. iPhone 15 Pro has an advanced Super Retina XDR display with ProMotion. It ramps up refresh rates to 120Hz when you need exceptional graphics performance. And ramps down to save power when you don't.",
  "ipad pro 12.9 Brilliant 12.9-inch Liquid Retina XDR display with ProMotion, True Tone, and P3 wide color M2 chip with 8-core CPU and 10-core GPU 12MP Wide camera, 10MP Ultra Wide back camera, and LIDAR Scanner for immersive AR 12MP Ultra Wide front camera with Center Stage Superfast Wi-Fi 6E USB-C connector with support for Thunderbolt / USB 4 Face ID for secure authentication and Apple Pay Go far with all-day battery life Works with Apple Pencil (2nd generation), Magic Keyboard, and Smart Keyboard Folio Support for Apple Pencil hover for more precise marking and sketching .",
  "macbook air M2 chip with next-generation CPU, GPU, and machine learning performance Faster 8-core CPU and up to 10-core GPU to power through complex tasks 16-core Neural Engine for advanced machine learning tasks Up to 24GB of faster unified memory makes everything you do super fluid Up to 20 percent faster for applying image filters and effects Up to 40 percent faster for editing complex video timelines Go all day with up to 18 hours of battery life Fanless design for silent operation 13.6-inch Liquid Retina display with 500 nits of brightness and P3 wide color for vibrant images and incredible detail 1080p FaceTime HD camera with twice the resolution and low-light performance Three-microphone array focuses on your voice instead of what’s going on around you Four-speaker sound system with Spatial Audio for an immersive listening experience Share content seamlessly between iPhone and Mac MagSafe charging port, two Thunderbolt ports, and headphone jack Backlit Magic Keyboard and Touch ID for secure unlock and payments Fast Wi-Fi 6 wireless connectivity Superfast SSD storage launches apps and opens files in an instant macOS Monterey lets you connect, share, and create like never before—across all your Apple devices. ",
  "Spatial audio with dynamic head tracking places sound all around you Adaptive EQ automatically tunes music to your ears All-new contoured design Force sensor lets you easily control your entertainment, answer or end calls, and more Sweat and water resistant3• Up to 6 hours of listening time with one charge Up to 30 hours total listening time with the MagSafe Charging Case2 Quick access to Siri by saying “Hey Siri” Effortless setup, in-ear detection, and automatic switching for a magical experience Easily share audio between two sets of AirPods on your iPhone, iPad, iPod touch, or Apple TV ." ,
  "Stay connected in style with the Apple Watch Ultra 2 GPS + cellular 49mm. Featuring GPS and cellular capabilities, this watch allows you to access data and make calls without being near your phone. Enjoy a comfortable fit with a platform that provides an array of features without compromising on style.Introducing the latest Apple Watch Ultra 2 GPS + cellular 49mm with Always-On Retina display up to 3000 nits and S9 SiP. Double tap gesture. It's equipped with precision finding for iPhones, Blood Oxygen app, and ECG app. It also features high and low heart rate notifications, irregular rhythm notifications, and low cardio fitness notifications. Plus, it's 100m water resistant and swimproof with a recreational dive up to 40m. With dual-frequency GPS and cellular connectivity, it has an amazing battery life – up to 36 hours & up to 72 hours in Low Power Mode with fast charging.Always-On Retina display, up to 3000 nits Blood Oxygen app, ECG app High and low heart rate notifications, Irregular rhythm notifications, Low cardio fitness notifications 100m water resistant. Swimproof. High-speed water sports. Recreational dive to 40m Precision dual-frequency GPS. Cellular connectivity. Battery: Up to 36 hours & up to 72 hours in Low Power Mode. Fast charging." ,
  ""
];
List<String> price = ["899 JD", "999 JD", "1,399 JD","159 JD","719 JD"];