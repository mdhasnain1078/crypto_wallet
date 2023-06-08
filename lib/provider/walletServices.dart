import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

  // Client httpClient = Client();
  // Web3Client ethClient = Web3Client("https://sepolia.infura.io/v3/fb23b527e82d45db8052f4fa745ae5b0", httpClient);
class WalletService with ChangeNotifier{

 Future<DeployedContract> loadContract()async{
    String abi = await rootBundle.loadString("assets/abi.json");
    print("4");
    String contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "PkCoin"), EthereumAddress.fromHex(contractAddress));
    print("5");
    return contract;
  }

  Future<List<dynamic>> query(String functionName , List<dynamic> args, Web3Client ethClient) async{
    final contract = await loadContract();
    print("1");
    final ethfunction = contract.function(functionName);
    print("2");
    final result = await ethClient.call(contract: contract, function: ethfunction, params: args);
    print(result);
    print("3");
    return result;
  } 
 
//  starts
  Future<dynamic> getBalance(String targetAddress, Web3Client ethClient) async{
    // EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", [], ethClient);
    print("0");
    return result[0];
  }

  Future<String> submit(String functionName, List<dynamic> args, Web3Client ethClient) async{
    EthPrivateKey credentials = EthPrivateKey.fromHex("5f67ca6bcb667e5e19b32869114e9787d15002de9ce5a9064bd1f39eecf2220e");

    DeployedContract contract = await loadContract();
    final ethfunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethfunction, parameters: args), fetchChainIdFromNetworkId: true);
    return result;
  }

//   Future<String> sendCoin() async{
//     var bigAmount = BigInt.from(myAmount);
//     var response = await submit("depositBalance", [bigAmount]);
//     print("deposit");
//     txHash = response;
//     return response;
//   }

//   Future<String> widrawCoin() async{
//     var bigAmount = BigInt.from(myAmount);
//     var response = await submit("widrawBalance", [bigAmount]);
//     txHash = response;

//     return response;
//   }
  
}