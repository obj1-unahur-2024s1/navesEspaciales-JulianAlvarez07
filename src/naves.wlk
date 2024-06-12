class Nave {
	var velocidad = 0
	var direccionAlSol = 0
	var combustible = 0
	
	method acelerar(aceleracion) {
		velocidad = 100000.min(velocidad + aceleracion)
	//	velocidad = (velocidad + aceleracion).min(100000)
	}
	method desacelerar(desaceleracion) {
		velocidad = 0.max(velocidad - desaceleracion)
	}
	method irHaciaElSol(){
		direccionAlSol = 10
	}
	method escaparDelSol(){
		direccionAlSol = -10
	}
	method ponerseParaleloAlSol(){
		direccionAlSol = 0
	}
	method acercarseUnPocoAlSol(){
		direccionAlSol = 10.min(direccionAlSol + 1)
	}
	method alejarseUnPocoDelSol(){
		direccionAlSol = -10.max(direccionAlSol - 1)
	}
	
	method cargarCombustible(cuanto) {combustible += cuanto}
	method descargarCombustible(cuanto) {combustible = 0.max(combustible - cuanto)}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() {
		return combustible >= 4000 and velocidad <= 12000 and self.adicionalTranquilidad()
	}
	//abstractos
	method adicionalTranquilidad()
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	
	method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad()
	}
	method tienePocaActividad()
}

class NaveBaliza inherits Nave{
	var colorBaliza = "azul" //se inicializa con un color random
	var cambioDeColor = false
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioDeColor = true
	}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method adicionalTranquilidad(){
		return colorBaliza != "rojo"
	}
	//abstracto
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	override method tienePocaActividad(){
		return not cambioDeColor
	}
}

class NavePasajeros inherits Nave{
	const cantPasajeros
	var racionesComida = 0
	var racionesBebida = 0
	var racionesDeComidasDadas = 0
	
	method servirComida(racion){
		self.descargarComida(racion)
		racionesDeComidasDadas += racionesComida.min(racion)
	}
	method cargarComida(racion){racionesComida += racion}
	method cargarBebida(racion){racionesBebida += racion}
	method descargarComida(racion){racionesComida = 0.max(racionesComida - racion)}
	method descargarBebida(racion){racionesBebida = 0.max(racionesBebida - racion)}
	
	override method prepararViaje(){
		super()
		self.cargarComida(cantPasajeros * 4)
		self.cargarBebida(cantPasajeros * 6)
		self.acercarseUnPocoAlSol()
	}
	override method adicionalTranquilidad(){ //sino tiene adicional devuelve verdadero
		return true
	}
	
	override method escapar(){
		self.acelerar(velocidad) 
	}
	override method avisar(){
		self.servirComida(cantPasajeros)
		self.descargarBebida(cantPasajeros * 2)
	}
	
	override method tienePocaActividad(){
		return racionesComida < 50
	}
}

class NaveCombate inherits Nave{
	var estaVisible = true
	var misilesDesplegados = true
	const mensajes = []
	
	method ponerseVisible() {estaVisible = true}
	method ponerseInvisible() {estaVisible = false}
	method estaInvisible() = not estaVisible
	
	method desplegarMisiles() {misilesDesplegados = true}
	method replegarMisiles() {misilesDesplegados = false}
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	method mensajesEmitidos(){
		return mensajes 
	}
	method primerMensajeEmitido(){
		mensajes.first() 
	}
	method ultimoMensajeEmitido() = mensajes.last()
	
	method esEscueta() = not mensajes.any({mensaje => mensaje.size() > 30})
					//		mensajes.all({mensaje=>mensaje.size() <=30})
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision")
	}
	override method adicionalTranquilidad(){
		return not misilesDesplegados
	}
	
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad(){
		return self.esEscueta()
	}
}

class NaveHospital inherits NavePasajeros {
	var quirofanosPreparados = true
	method prepararQuirofanos() {quirofanosPreparados = true}
	method noPrepararQuirofanos() {quirofanosPreparados = false}
	override method adicionalTranquilidad(){
		return not quirofanosPreparados
	}
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
}

class NaveSigilosa inherits NaveCombate {
	override method adicionalTranquilidad(){
		return super() and not self.estaInvisible()
	}
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}

























