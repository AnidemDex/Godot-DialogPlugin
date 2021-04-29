# ResourceArray
#### **Heredado de:** [Resource][resource_class]
#### **Heradado por:** EventsArray, PortraitsArray
Una implementación para crear un arreglo de recursos de Godot.

Debe existir [debido a un bug][array_bug] relacionado con las exportaciones de Godot.
> Este error será arreglado en Godot 4.0 gracias a godotengine/godot#41983.
Basado en [array_map.gd][1] de @willnationsdev

## Metodos
Type|Name
-----|-----
void|add
void|remove
array|get_resources

## Descripción de metodos
 - void **add(resource: [Resource][resource_class])**
- void **remove(resource: [Resource][resource_class])**
- Array **get_resources()**

[resource_class]:https://docs.godotengine.org/es/stable/classes/class_resource.html#class-resource
[array_bug]: https://github.com/godotengine/godot/issues/20436
[1]:https://github.com/godot-extended-libraries/godot-next/blob/master/addons/godot-next/resources/array_map.gd
[2]:https://github.com/godot-extended-libraries/godot-next/blob/master/addons/godot-next/resources/array_map.gd