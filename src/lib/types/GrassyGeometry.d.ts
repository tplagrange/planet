import type { Vector3 } from 'three';

type GrassyGeometryProperties = {
	ambientOcclusionAttenuation: number;
	ambientOcclusionBias: number;
	color: string;
	density: number;
	lightDirection: Vector3;
	noiseMax: number;
	noiseMin: number;
	rotationSpeed: number;
	shellCount: number;
	shellCurvature: number;
	shellLength: number;
	shellThickness: number;
	windSpeed: number;
	windStrength: number;
};

type GrassyGeometrySettings = {
	'AO Attenuation': number;
	'AO Bias': number;
	'Rotation Speed': number;
	'Light Direction X': number;
	'Light Direction Y': number;
	'Light Direction Z': number;
	'Grass Color': string;
	'Noise Max': number;
	'Noise Min': number;
	'Shell Count': number;
	'Shell Curvature': number;
	'Shell Length': number;
	'Shell Thickness': number;
	Density: number;
	'Wind Speed': number;
	'Wind Strength': number;
};
