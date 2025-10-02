import {
  type Feature,
  type FeatureChoiced,
  FeatureColorInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const input_blood_color: Feature<string> = {
  name: 'Blood Colour Input',
  description:
    'NOTE: This matches the colour to the BRIGHTEST px. So, make this slightly (about 10?) more luminescent (HSL) than you want the blood to be.',
  component: FeatureColorInput,
};

export const select_blood_color: FeatureChoiced = {
  name: 'Blood Color Preset',
  description: 'NOTE: Use \'Species\' for no change, or \'Custom\' to display the colour sliders.',
  component: FeatureDropdownInput,
};
