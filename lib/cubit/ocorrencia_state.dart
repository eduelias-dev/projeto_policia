import 'package:equatable/equatable.dart';
import '../models/ocorrencias.dart';

/// Estados possíveis do OcorrenciaCubit

/// Estado inicial quando o cubit é criado
class OcorrenciaInitial extends Equatable {
  const OcorrenciaInitial();

  @override
  List<Object?> get props => [];
}

/// Estado de carregamento durante operações assíncronas
class OcorrenciaLoading extends Equatable {
  const OcorrenciaLoading();

  @override
  List<Object?> get props => [];
}

/// Estado de sucesso com a lista de ocorrências carregada
class OcorrenciaLoaded extends Equatable {
  final List<Ocorrencia> ocorrencias;

  const OcorrenciaLoaded(this.ocorrencias);

  @override
  List<Object?> get props => [ocorrencias];
}

/// Estado de erro com mensagem
class OcorrenciaError extends Equatable {
  final String mensagem;

  const OcorrenciaError(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
