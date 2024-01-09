import type { GrassyGeometrySettings } from '$lib/types/GrassyGeometry';
import { defaultSettings } from './default';

export const stylizedSettings: GrassyGeometrySettings = {
	...defaultSettings,
	'Grass Color': '#49df4b',
	'Light Direction X': 1,
	'Light Direction Y': 1,
	'Light Direction Z': 1,
	'Noise Max': 1.0,
	'Noise Min': 0.69,
	'Shell Count': 256,
	'Shell Length': 0.5,
	'Shell Thickness': 25,
	Density: 128
};
