extends Control
tool

signal choice_picked


onready var line_edit: LineEdit = $VBoxContainer/LineEdit
onready var item_list: ItemList = $VBoxContainer/ItemList
onready var btn_pick:Button = $VBoxContainer/Button
export(String) var pick_text: String setget _set_pick_text
export(Array, String) var values: Array setget _set_values


func _set_values(new_values: Array) -> void:
    values = new_values
    _refresh()


func _set_pick_text(new_pick_text: String) -> void:
    pick_text = new_pick_text
    if btn_pick:
        btn_pick.text = pick_text


func _refresh() -> void:
    _clear()
    _populate()


func _clear() -> void:
    if item_list:
        item_list.clear()


func _populate() -> void:
    if line_edit == null || item_list == null:
        return

    if values == null || values.size() == 0:
        return

    for value_index in range(values.size()):
        var value = values[value_index]
        assert(value is String, "values must be an array of strings!")

        if !line_edit.text.empty() && !(line_edit.text.to_lower() in value.to_lower()):
            continue

        item_list.add_item(value)
        item_list.set_item_metadata(item_list.get_item_count() - 1, value_index)


func _ready() -> void:
    btn_pick.connect("pressed", self, "_on_btn_pick")
    line_edit.connect("text_changed", self, "_on_filter_text_changed")
    _refresh()
    if btn_pick:
        btn_pick.text = pick_text


func _on_btn_pick() -> void:
    var selected_items: PoolIntArray = item_list.get_selected_items()
    if selected_items.size() == 0:
        return

    var selected_item = selected_items[0]
    var selected_value_index = item_list.get_item_metadata(selected_item)
    emit_signal("choice_picked", selected_value_index)


func _on_filter_text_changed(_new_text: String) -> void:
    _refresh()
