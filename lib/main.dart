import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/contract_controller.dart';
import 'data/contract_database.dart';
import 'data/contract_repository.dart';
import 'pages/contract_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ContractRepository repositorio = ContractRepository(
    ContractDatabase.instance,
  );
  runApp(CadastroApp(repositorio: repositorio));
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key, required this.repositorio});

  final ContractRepository repositorio;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ContractController>>[
        ChangeNotifierProvider<ContractController>(
          create: (_) => ContractController(repositorio),
        ),
      ],
      child: MaterialApp(
        title: 'Cadastro de Contratos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const ContractListPage(),
      ),
    );
  }
}
