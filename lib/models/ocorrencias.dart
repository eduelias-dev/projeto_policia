/// Modelo de Ocorrência para registro de ocorrências offline
class Ocorrencia {
  final int? id; // ID gerado automaticamente pelo SQLite
  final String titulo;
  final String descricao;
  final String data;

  Ocorrencia({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  /// Converte a ocorrência para um Map para ser salvo no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }

  /// Cria uma ocorrência a partir de um Map recuperado do banco de dados
  factory Ocorrencia.fromMap(Map<String, dynamic> map) {
    return Ocorrencia(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      data: map['data'] as String,
    );
  }

  /// Cria uma cópia da ocorrência com campos atualizados
  Ocorrencia copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? data,
  }) {
    return Ocorrencia(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
    );
  }
}