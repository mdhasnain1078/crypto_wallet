import 'package:dapp/provider/walletServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

import '../widget/slider_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client? httpClient;
  Web3Client? ethClient;
  bool data = false;
  final myAddress = "0x7508267C20BE568C55E036937C564c92EDEbAF03";
  int myAmount = 0;
  var myData;
  String? txHash;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client("https://sepolia.infura.io/v3/fb23b527e82d45db8052f4fa745ae5b0", httpClient as Client);
    myData = Provider.of<WalletService>(context, listen: false).getBalance(myAddress, ethClient!);
    data = true;
    super.initState();
  }


  // Future<DeployedContract> loadContract()async{
  //   String abi = await rootBundle.loadString("assets/abi.json");
  //   String contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";
  //   final contract = DeployedContract(ContractAbi.fromJson(abi, "PkCoin"), EthereumAddress.fromHex(contractAddress));
  //   return contract;
  // }

  // Future<List<dynamic>> query(String functionName , List<dynamic> args) async{
  //   final contract = await loadContract();
  //   final ethfunction = contract.function(functionName);
  //   final result = await ethClient!.call(contract: contract, function: ethfunction, params: args);
  //   return result;
  // } 

  // Future<void> getBalance(String targetAddress) async{
  //   EthereumAddress address = EthereumAddress.fromHex(targetAddress);
  //   List<dynamic> result = await query("getBalance", []);
  //   myData = result[0];
  //   data = true;
  //   setState(() {
      
  //   });
  // }

  // Future<String> submit(String functionName, List<dynamic> args) async{
  //   EthPrivateKey credentials = EthPrivateKey.fromHex("5f67ca6bcb667e5e19b32869114e9787d15002de9ce5a9064bd1f39eecf2220e");
  //   DeployedContract contract = await loadContract();
  //   final ethfunction = contract.function(functionName);
  //   final result = await ethClient!.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethfunction, parameters: args), fetchChainIdFromNetworkId: true);
  //   return result;
  // }

  // Future<String> sendCoin() async{
  //   var bigAmount = BigInt.from(myAmount);
  //   var response = await submit("depositBalance", [bigAmount]);
  //   print("deposit");
  //   txHash = response;
  //   return response;
  // }

  // Future<String> widrawCoin() async{
  //   var bigAmount = BigInt.from(myAmount);
  //   var response = await submit("widrawBalance", [bigAmount]);
  //   txHash = response;
  //   return response;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$PKCOINS".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
                  child: VStack([
            "Balance".text.xl2.gray700.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "\$1".text.bold.xl6.makeCentered().shimmer()
                : const CircularProgressIndicator().centered()
          ]))
              .white
              .size(context.screenWidth, context.percentHeight * 20)
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          SliderWidget(min: 0, max: 100, finalVal: (double value) {
            myAmount = (value*100).round();
          }, ).centered(),
          HStack([
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () async{
                  setState(() {
                    data = false;
                  });
                  myData =  await Provider.of<WalletService>(context, listen: false).getBalance(myAddress, ethClient!);
                    setState(() {
                    data = true;
                  });},
                icon: const Icon(Icons.refresh),
                label: "Refresh".text.white.make()).h(50),
                ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                // sendCoin(),
                icon: const Icon(Icons.call_made_outlined),
                label: "Deposit".text.white.make()).h(50),
                ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
                onPressed: (){},
                // widrawCoin(),
                icon: const Icon(Icons.call_received_outlined),
                label: "Withdraw".text.white.make()).h(50)
          ],
          alignment: MainAxisAlignment.spaceAround,
          axisSize: MainAxisSize.max,
          ).p16(),
          if(txHash != null) txHash!.text.black.makeCentered().p16()
        ])
      ]),
    );
  }
}

