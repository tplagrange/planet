<script lang="ts">
	import { T } from '@threlte/core';
	import { OrbitControls } from '@threlte/extras';
	import GUI from 'lil-gui';
	import { Vector3 } from 'three';

	import type { GrassyGeometrySettings, GrassyGeometryProperties } from '$lib/types/GrassyGeometry';
	import { stylizedSettings } from '../presets/stylized';
	import Grass from './GrassyGeometry.svelte';
	import Atmosphere from './Atmosphere.svelte';
	import Ring from './Ring.svelte';

	const atmosphereSettingsToPropertiesMap: Map<
		keyof AtmosphereSettings,
		keyof AtmosphereProperties
	> = new Map([
		['Color', 'color'],
		['Intensity', 'intensity'],
		['Scale', 'scale']
	]);

	const grassyGeometrySettingsToPropertiesMap: Map<
		keyof GrassyGeometrySettings,
		keyof GrassyGeometryProperties
	> = new Map([
		['AO Attenuation', 'ambientOcclusionAttenuation'],
		['AO Bias', 'ambientOcclusionBias'],
		['Light Direction X', 'lightDirection'],
		['Light Direction Y', 'lightDirection'],
		['Light Direction Z', 'lightDirection'],
		['Density', 'density'],
		['Grass Color', 'color'],
		['Noise Max', 'noiseMax'],
		['Noise Min', 'noiseMin'],
		['Rotation Speed', 'rotationSpeed'],
		['Shell Count', 'shellCount'],
		['Shell Curvature', 'shellCurvature'],
		['Shell Length', 'shellLength'],
		['Shell Thickness', 'shellThickness'],
		['Wind Speed', 'windSpeed'],
		['Wind Strength', 'windStrength']
	]);

	const atmosphereSettingsToProperties = (settings: AtmosphereSettings): AtmosphereProperties => {
		const properties: Record<string, any> = {};

		Object.keys(settings).forEach((key) => {
			const property = atmosphereSettingsToPropertiesMap.get(key as keyof AtmosphereSettings);

			if (!property) return;

			properties[property] = settings[key as keyof AtmosphereSettings];
		});

		return properties as AtmosphereProperties;
	};

	const grassyGeometrySettingsToProperties = (
		settings: GrassyGeometrySettings
	): GrassyGeometryProperties => {
		const properties: Record<string, any> = {};

		Object.keys(settings).forEach((key) => {
			const property = grassyGeometrySettingsToPropertiesMap.get(
				key as keyof GrassyGeometrySettings
			);

			if (!property) return;

			if (property === 'lightDirection') {
				properties[property] = new Vector3(
					settings['Light Direction X'],
					settings['Light Direction Y'],
					settings['Light Direction Z']
				);
				return;
			}

			properties[property] = settings[key as keyof GrassyGeometrySettings];
		});

		return properties as GrassyGeometryProperties;
	};

	const defaultAtmosphereSettings: AtmosphereSettings = {
		Color: '#69c7f2',
		Intensity: 0.5,
		Scale: 1.6
	};
	const defaultGrassyGeometrySettings: GrassyGeometrySettings = stylizedSettings;

	let atmosphereProperties = atmosphereSettingsToProperties(defaultAtmosphereSettings);

	let grassyGeometryProperties = grassyGeometrySettingsToProperties(defaultGrassyGeometrySettings);

	const createPanel = (
		grassyGeometrySettings: GrassyGeometrySettings,
		atmosphereSettings: AtmosphereSettings
	) => {
		const panel = new GUI();

		panel.onChange(({ property, value }) => {
			const incomingPropertyKey = grassyGeometrySettingsToPropertiesMap.get(
				property as keyof GrassyGeometrySettings
			);

			if (!incomingPropertyKey) return;

			if (incomingPropertyKey === 'lightDirection') {
				const currentValue = grassyGeometryProperties[incomingPropertyKey];

				grassyGeometryProperties[incomingPropertyKey] = new Vector3(
					property === 'Light Direction X' ? value : currentValue.x,
					property === 'Light Direction Y' ? value : currentValue.y,
					property === 'Light Direction Z' ? value : currentValue.z
				);
				return;
			}

			const currentValue = (grassyGeometryProperties as Record<string, any>)[incomingPropertyKey];
			const incomingValue = value;

			if (currentValue === incomingValue) return;

			(grassyGeometryProperties as Record<string, any>)[incomingPropertyKey] = value;
		});

		panel.add(grassyGeometrySettings, 'Rotation Speed', 0, 1, 0.01);
		panel.addColor(grassyGeometrySettings, 'Grass Color');
		panel.add(grassyGeometrySettings, 'Density', 1, 2048, 4);

		const atmosphereFolder = panel.addFolder('Atmosphere');
		atmosphereFolder.addColor(atmosphereSettings, 'Color');
		atmosphereFolder.add(atmosphereSettings, 'Intensity', 0, 1, 0.01);
		atmosphereFolder.add(atmosphereSettings, 'Scale', 0, 10, 0.01);

		atmosphereFolder.onChange(({ property, value }) => {
			const incomingPropertyKey = atmosphereSettingsToPropertiesMap.get(
				property as keyof AtmosphereSettings
			);

			if (!incomingPropertyKey) return;

			const currentValue = (atmosphereProperties as Record<string, any>)[incomingPropertyKey];
			const incomingValue = value;

			if (currentValue === incomingValue) return;

			(atmosphereProperties as Record<string, any>)[incomingPropertyKey] = value;
		});

		const windFolder = panel.addFolder('Wind');
		windFolder.add(grassyGeometrySettings, 'Wind Speed', 0, 1, 0.01);
		windFolder.add(grassyGeometrySettings, 'Wind Strength', 0, 1, 0.01);

		const lightingFolder = panel.addFolder('Lighting');
		lightingFolder.add(grassyGeometrySettings, 'Light Direction X', -1, 1, 0.01);
		lightingFolder.add(grassyGeometrySettings, 'Light Direction Y', -1, 1, 0.01);
		lightingFolder.add(grassyGeometrySettings, 'Light Direction Z', -1, 1, 0.01);
		const ambientOcclusionFolder = lightingFolder.addFolder('Ambient Occlusion');
		ambientOcclusionFolder.add(grassyGeometrySettings, 'AO Attenuation', 0, 10, 0.01);
		ambientOcclusionFolder.add(grassyGeometrySettings, 'AO Bias', 0, 1, 0.01);

		const shellTexturingFolder = panel.addFolder('Shell Texturing');
		shellTexturingFolder.add(grassyGeometrySettings, 'Shell Count', 1, 512, 4);
		shellTexturingFolder.add(grassyGeometrySettings, 'Shell Curvature', 0, 100, 0.1);
		shellTexturingFolder.add(grassyGeometrySettings, 'Shell Length', 0.01, 1, 0.01);
		shellTexturingFolder.add(grassyGeometrySettings, 'Shell Thickness', 1, 50, 1);
		shellTexturingFolder.add(grassyGeometrySettings, 'Noise Min', 0, 1, 0.01);
		shellTexturingFolder.add(grassyGeometrySettings, 'Noise Max', 0, 1, 0.01);
	};

	createPanel(defaultGrassyGeometrySettings, defaultAtmosphereSettings);
</script>

<T.PerspectiveCamera makeDefault position={[0, 0, 20]} fov={15}>
	<OrbitControls autoRotate={false} enableDamping autoRotateSpeed={0.5} />
</T.PerspectiveCamera>

<Ring />
<Atmosphere properties={atmosphereProperties} />
<Grass properties={grassyGeometryProperties} />
