import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_policia/components/cartao_ocorrencia.dart';
import 'package:projeto_policia/components/formulario_ocorrencia_sheet.dart';
import '../cubit/ocorrencia_cubit.dart';
import '../cubit/ocorrencia_state.dart';

/// Página principal do aplicativo
/// Exibe a lista de ocorrências e permite adicionar novas ocorrências
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Controllers para os campos de entrada
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _descricaoController = TextEditingController();

    // Carrega as ocorrências ao iniciar a página
    context.read<OcorrenciaCubit>().carregarOcorrencias();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  /// Abre o BottomSheet para adicionar nova ocorrência
  void _abrirFormularioOcorrencia() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FormularioOcorrenciaSheet(
        tituloController: _tituloController,
        descricaoController: _descricaoController,
        onSalvar: _salvarOcorrencia,
      ),
    );
  }

  /// Salva uma nova ocorrência
  void _salvarOcorrencia() {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Adiciona a ocorrência via Cubit
    context.read<OcorrenciaCubit>().adicionarOcorrencia(
      titulo: titulo,
      descricao: descricao,
    );

    // Limpa os campos
    _tituloController.clear();
    _descricaoController.clear();

    // Fecha o BottomSheet
    Navigator.pop(context);

    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ocorrência registrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ocorrências Remotas'),
        elevation: 0,
      ),
      body: BlocBuilder<OcorrenciaCubit, dynamic>(
        builder: (context, state) {
          // Estado de carregamento
          if (state is OcorrenciaLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Estado de erro
          if (state is OcorrenciaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.mensagem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OcorrenciaCubit>().carregarOcorrencias();
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Estado de sucesso com lista de ocorrências
          if (state is OcorrenciaLoaded) {
            if (state.ocorrencias.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhuma ocorrência registrada',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _abrirFormularioOcorrencia,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Ocorrência'),
                    ),
                  ],
                ),
              );
            }

            // Lista de ocorrências
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.ocorrencias.length,
              itemBuilder: (context, index) {
                final ocorrencia = state.ocorrencias[index];
                return CartaoOcorrencia(
                  ocorrencia: ocorrencia,
                  onDelete: () {
                    _deletarOcorrencia(ocorrencia.id!);
                  },
                );
              },
            );
          }

          // Estado inicial
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.note_add_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('Comece a registrar ocorrências'),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _abrirFormularioOcorrencia,
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Ocorrência'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioOcorrencia,
        tooltip: 'Adicionar Ocorrência',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Deleta uma ocorrência após confirmação
  void _deletarOcorrencia(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Deleção'),
        content: const Text('Tem certeza que deseja deletar esta ocorrência?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<OcorrenciaCubit>().deletarOcorrencia(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ocorrência deletada'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}