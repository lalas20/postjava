enum Estado {
  configuracion(value: 2400, estado: 'Configurado'),
  habilitado(value: 2401, estado: 'Habilitado'),
  deshabilitado(value: 2402, estado: 'Deshabilitado'),
  baja(value: 2403, estado: 'Baja');

  const Estado({required this.value, required this.estado});
  final int value;
  final String estado;

  String get stateTxt => estado.toUpperCase();
  int get stateVal => value;
}
