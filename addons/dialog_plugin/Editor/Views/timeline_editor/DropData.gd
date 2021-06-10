tool
extends Control

# Lo cree para gestionar los eventos que iban a ser añadidos
# bajo la promesa de Drag&Drop.
# Puede ser añadido a cualquier nodo, emitira una señal si en su area
# le es soltado un DialogEventResource

signal item_added(item)

func can_drop_data(position, data):
	if not data[1].is_connected("tree_exited", self, "hide"):
		data[1].connect("tree_exited", self, "hide",[], CONNECT_ONESHOT)
	return data[0] is DialogEventResource

func drop_data(position, data):
	emit_signal("item_added", data[0])
