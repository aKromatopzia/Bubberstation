///see modular_zubbers\code\modules\quirks\neutral_quirks\unique_blood_color.dm

///manual colour input
/datum/preference/color/input_blood_color
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "input_blood_color"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/input_blood_color/create_default_value()
	return BLOOD_COLOR_BLACK

/datum/preference/color/input_blood_color/is_accessible(datum/preferences/preferences)
	var/passed_init = ..(preferences)
	var/option_enabled = FALSE
	if((preferences.read_preference(/datum/preference/choiced/select_blood_color)) == "Custom")
		option_enabled = TRUE

	return option_enabled && passed_init

//handled by select_blood_color
/datum/preference/color/input_blood_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

///colour preset selection
/datum/preference/choiced/select_blood_color
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "select_blood_color"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/select_blood_color/create_default_value()
	return "Species"

/datum/preference/choiced/select_blood_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return initial(species_type.blood_color_customization) == BLOOD_COLOR_CHOICE

/datum/preference/choiced/select_blood_color/init_possible_values()
	return list("Custom", "Species") + assoc_to_keys(GLOB.custom_blood_colors)

/datum/preference/choiced/select_blood_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!preferences)
		return FALSE
	var/selected_color = value || "Species"
	var/color_code = NONE //this should only ever be a hex color
	switch(selected_color)
		if("Species")
			return FALSE
		if("Custom")
			color_code = preferences.read_preference(/datum/preference/color/input_blood_color)
		else
			color_code = GLOB.custom_blood_colors[selected_color]
	if(color_code == null)
		CRASH("select_blood_color/apply_to_human failed for [target.name]")
	var/datum/blood_type/old_blood = target.dna.blood_type

	if(color_code == old_blood.get_color())
		return FALSE //don't make unique versions of normal blood
	testing("passing to dye_blood() with args target = [target] & color_code = [color_code]")
	target.dna.species.dye_blood(target = target, color_code = color_code)
	return TRUE

//here temporarily for ease of review
/datum/species/proc/dye_blood(datum/source, mob/living/carbon/human/target, color_code, update_cached_blood_dna_info)
	SIGNAL_HANDLER
	var/datum/blood_type/new_blood = NONE
	new_blood = get_blood_type("[target.dna.blood_type] ([color_code])") //for example, A-_#69af19
	//check if blood type already exists before making new instance. in case somebody else is using the same color
	if(isnull(new_blood))
		var/recolor_type = target.dna.blood_type.recolor_blood_type
		testing("recolor_type = [recolor_type]")
		new_blood = new recolor_type(override = color_code, orig = target.dna.blood_type)
		GLOB.blood_types[new_blood.id] = new_blood
	testing("new_blood = [new_blood]")
	NOTICE("finalized new blood type [new_blood.id] for [target.name]")
	target.dna.species.exotic_bloodtype = new_blood
	testing("target.dna.species.exotic_bloodtype = [target.dna.species.exotic_bloodtype]")
	target.set_blood_type(new_blood)
	testing("target.dna.blood_type = [target.dna.blood_type]")
	return TRUE
