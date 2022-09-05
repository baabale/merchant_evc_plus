import 'package:flutter/material.dart';
import 'package:merchant_evc_plus/merchant_evc_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchant EvcPlus API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Merchant EvcPlus API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  late String merchantUid, apiUserId, apiKey, phone;
  late num amount;
  bool isLoading = false;

  void makePayment() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
      if (_formKey.currentState!.validate()) {
        final merchantEvcPlus = MerchantEvcPlus(
          apiKey: apiKey,
          merchantUid: merchantUid,
          apiUserId: apiUserId,
        );
        setState(() => isLoading = !isLoading);
        await merchantEvcPlus.makePayment(
          transactionInfo: TransactionInfo(
            payerPhoneNumber: phone,
            amount: amount,
            invoiceId: 'INV-PLAN-Test',
          ),
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Payment Successful'),
            ));
          },
          onFailure: (error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error),
            ));
          },
        );
        setState(() => isLoading = !isLoading);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'API Configuration',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'NB. In order to have these credentials, you need to contact Hormuud Telecom',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      validator: (value) {
                        if (value != null) if (value.isEmpty)
                          return 'Field required';
                      },
                      onSaved: (newValue) {
                        if (newValue != null) merchantUid = newValue;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Merchant Uid',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) {
                        if (value != null) if (value.isEmpty)
                          return 'Field required';
                      },
                      onSaved: (newValue) {
                        if (newValue != null) apiUserId = newValue;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'API UserId',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) {
                        if (value != null) if (value.isEmpty)
                          return 'Field required';
                      },
                      onSaved: (newValue) {
                        if (newValue != null) apiKey = newValue;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'API Key',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Testing Section'),
                    const SizedBox(height: 10),
                    // Testing Fields
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value != null) if (value.isEmpty)
                                return 'Field required';
                            },
                            onSaved: (newValue) {
                              if (newValue != null) phone = newValue;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                              hintText: '25261123456',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null) if (value.isEmpty)
                                return 'Field required';
                            },
                            onSaved: (newValue) {
                              if (newValue != null)
                                amount = double.tryParse(newValue) ?? 0;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount',
                              hintText: '0.5',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RawMaterialButton(
                      onPressed: makePayment,
                      child: Text(
                        'Save & Test',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      constraints: BoxConstraints.tightFor(
                        width: double.infinity,
                        height: 56,
                      ),
                      fillColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('About Developer'),
            content: Text(
              'This plugin has been developed by Abdirahman Baabale. \n\nMail: me@baabale.com \nWeb: baabale.com',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok, got it!'),
              ),
            ],
          ),
        ),
        tooltip: 'DEVELOPER',
        child: const Icon(Icons.info),
      ),
    );
  }
}
