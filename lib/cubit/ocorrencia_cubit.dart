import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/ocorrencias.dart';
import 'ocorrencia_state.dart';

/// Cubit responsável pela gerência de estado das ocorrências
/// Utiliza o padrão BLoC com Cubit para gerenciar as operações
class OcorrenciaCubit extends Cubit<dynamic> {
  final DatabaseHelper _databaseHelper;

  OcorrenciaCubit({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper(),
        super(const OcorrenciaInitial());

  /// Carrega todas as ocorrências do banco de dados
  Future<void> carregarOcorrencias() async {
    try {
      emit(const OcorrenciaLoading());
      
      final ocorrencias = await _databaseHelper.fetchOcorrencias();
      
      emit(OcorrenciaLoaded(ocorrencias));
    } catch (e) {
      emit(OcorrenciaError('Erro ao carregar ocorrências: ${e.toString()}'));
    }
  }

  /// Adiciona uma nova ocorrência
  Future<void> adicionarOcorrencia({
    required String titulo,
    required String descricao,
  }) async {
    try {
      emit(const OcorrenciaLoading());

      // Formata a data atual
      final dataAtual = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      final novaOcorrencia = Ocorrencia(
        titulo: titulo,
        descricao: descricao,
        data: dataAtual,
      );

      await _databaseHelper.insertOcorrencia(novaOcorrencia);

      // Recarrega a lista de ocorrências
      await carregarOcorrencias();
    } catch (e) {
      emit(OcorrenciaError('Erro ao adicionar ocorrência: ${e.toString()}'));
    }
  }

  /// Deleta uma ocorrência pelo ID
  Future<void> deletarOcorrencia(int id) async {
    try {
      emit(const OcorrenciaLoading());

      await _databaseHelper.deleteOcorrencia(id);

      // Recarrega a lista de ocorrências
      await carregarOcorrencias();
    } catch (e) {
      emit(OcorrenciaError('Erro ao deletar ocorrência: ${e.toString()}'));
    }
  }

  /// Atualiza uma ocorrência existente
  Future<void> atualizarOcorrencia({
    required int id,
    required String titulo,
    required String descricao,
  }) async {
    try {
      emit(const OcorrenciaLoading());

      final dataAtual = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      final ocorrenciaAtualizada = Ocorrencia(
        id: id,
        titulo: titulo,
        descricao: descricao,
        data: dataAtual,
      );

      await _databaseHelper.updateOcorrencia(ocorrenciaAtualizada);

      // Recarrega a lista de ocorrências
      await carregarOcorrencias();
    } catch (e) {
      emit(OcorrenciaError('Erro ao atualizar ocorrência: ${e.toString()}'));
    }
  }
}
