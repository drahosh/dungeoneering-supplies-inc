extends PanelContainer

func _ready() -> void:
	$Current/HBoxContainer/Hiring.pressed.connect(func(): toggle_hiring(true))
	$Hireable/Back.pressed.connect(func(): toggle_hiring(false))
	$Current/HBoxContainer/Autoequip.pressed.connect(autoequip_all)

	Guilds.changed_hireable_heroes.connect(setup_hireable)
	Guilds.changed_hired_heroes.connect(setup_hired)
	setup_hireable()
	setup_hired()


func toggle_hiring(hiring: bool):
	$Current.visible = not hiring
	$Hireable.visible = hiring


func autoequip_all():
	for child in $Current/ScrollContainer/Heroes.get_children():
		child.hero.autoequip()


func setup_hired():
	for child in $Current/ScrollContainer/Heroes.get_children():
		child.queue_free()

	for hero: Hero in Guilds.hired_heroes:
		$Current/ScrollContainer/Heroes.add_child(HeroView.get_new(hero))


func setup_hireable():
	for child in $Hireable/ScrollContainer/Heroes.get_children():
		child.queue_free()
	for hero in Guilds.hireable_heroes:
		$Hireable/ScrollContainer/Heroes.add_child(HeroView.get_new(hero, true))
