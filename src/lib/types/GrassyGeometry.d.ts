import type { Vector3 } from 'three';

type GrassyGeometryProperties = {
	color: string;
	density: number;
	lightDirection: Vector3;
	noiseMax: number;
	noiseMin: number;
	shellCount: number;
	shellLength: number;
	shellThickness: number;
};

type GrassyGeometrySettings = {
	'Light Direction X': number;
	'Light Direction Y': number;
	'Light Direction Z': number;
	'Grass Color': string;
	'Noise Max': number;
	'Noise Min': number;
	'Shell Count': number;
	'Shell Length': number;
	'Shell Thickness': number;
	Density: number;
};
