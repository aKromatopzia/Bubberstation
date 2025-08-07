//todo: move these defins to ~~bbubber_defines

/// Dummy blood type for 'human' blood, used in the species_blood pref to select humanoid blood types,
//before assigning a specific from the list
#define BLOOD_TYPE_HUMAN

/// Whether a species can change their blood type preset, or not. Important for haemophages and proteans, e.g
#define SPECIES_BLOOD_FORCED 0
#define SPECIES_BLOOD_OPTIONAL 1

/datum/preference/choiced/species_blood_color
	savefile_key = "species_blood_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES

/datum/preference/choiced/species_blood_type/create_default_value()
	return BLOOD_COLOR_RED

/datum/preference/choiced/species_blood_type
	savefile_key = "species_blood_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES


/datum/preference/choiced/species_blood_type/create_default_value()
	return BLOOD_TYPE_HUMAN

/datum/preference/choiced/species_blood_type/init_possible_values()
	return list(
		BLOOD_TYPE_HUMAN,
		BLOOD_TYPE_NANITE_SLURRY,
		BLOOD_TYPE_COPPER,
		BLOOD_TYPE_OIL,
		BLOOD_TYPE_H2O,
		)

/datum/preference/choiced/species_blood_type/is_accessible(datum/preferences/preferences)
	return ..() && is_usable(preferences)

/datum/preference/choiced/species_blood_type/proc/is_usable(datum/preferences/preferences)
	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return initial(species_type.blood_customization) == SPECIES_BLOOD_OPTIONAL
