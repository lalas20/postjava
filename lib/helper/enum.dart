enum Estado {
  configuracion(value: 2400, estado: 'CONFIGURACION'),
  habilitado(value: 2401, estado: 'CONFIGURACION'),
  deshabilitado(value: 2402, estado: 'CONFIGURACION'),
  baja(value: 2403, estado: 'CONFIGURACION');

  const Estado({required this.value, required this.estado});
  final int value;
  final String estado;

  String get stateTxt => estado.toUpperCase();
  int get stateVal => value;
}
