<script lang="ts">
	import { T } from '@threlte/core';
	import { OrbitControls } from '@threlte/extras';
	import Grass from './GrassyGeometry.svelte';

	import GUI from 'lil-gui';
	import { Vector3 } from 'three';

	import type { GrassyGeometrySettings, GrassyGeometryProperties } from '$lib/types/GrassyGeometry';

	const settingsToPropertiesMap: Map<keyof GrassyGeometrySettings, keyof GrassyGeometryProperties> =
		new Map([
			['Light Direction X', 'lightDirection'],
			['Light Direction Y', 'lightDirection'],
			['Light Direction Z', 'lightDirection'],
			['Density', 'density'],
			['Grass Color', 'color'],
			['Noise Max', 'noiseMax'],
			['Noise Min', 'noiseMin'],
			['Shell Count', 'shellCount'],
			['Shell Length', 'shellLength'],
			['Shell Thickness', 'shellThickness']
		]);

	const settingsToProperties = (settings: GrassyGeometrySettings): GrassyGeometryProperties => {
		const properties: Record<string, any> = {};

		Object.keys(settings).forEach((key) => {
			const property = settingsToPropertiesMap.get(key as keyof GrassyGeometrySettings);

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

	const defaultSettings: GrassyGeometrySettings = {
		'Grass Color': '#7CFC00',
		'Light Direction X': 1,
		'Light Direction Y': 1,
		'Light Direction Z': 1,
		'Noise Max': 1.0,
		'Noise Min': 0.7,
		'Shell Count': 256,
		'Shell Length': 0.2,
		'Shell Thickness': 20,
		Density: 512
	};

	let grassyGeometryProperties = settingsToProperties(defaultSettings);

	const createPanel = (settings: GrassyGeometrySettings) => {
		const panel = new GUI();

		panel.onChange(({ property, value }) => {
			const incomingPropertyKey = settingsToPropertiesMap.get(
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

		panel.addColor(settings, 'Grass Color');
		panel.add(settings, 'Density', 1, 2048, 4);

		const shellTexturingFolder = panel.addFolder('Shell Texturing');
		shellTexturingFolder.add(settings, 'Shell Count', 1, 512, 4);
		shellTexturingFolder.add(settings, 'Shell Length', 0.01, 1, 0.01);
		shellTexturingFolder.add(settings, 'Shell Thickness', 1, 50, 1);
		shellTexturingFolder.add(settings, 'Noise Min', 0, 1, 0.01);
		shellTexturingFolder.add(settings, 'Noise Max', 0, 1, 0.01);

		const lightingFolder = panel.addFolder('Lighting');
		lightingFolder.add(settings, 'Light Direction X', -1, 1, 0.01);
		lightingFolder.add(settings, 'Light Direction Y', -1, 1, 0.01);
		lightingFolder.add(settings, 'Light Direction Z', -1, 1, 0.01);
	};

	createPanel(defaultSettings);
</script>

<T.PerspectiveCamera makeDefault position={[0, 0, 20]} fov={15}>
	<OrbitControls autoRotate={false} enableDamping autoRotateSpeed={0.5} />
</T.PerspectiveCamera>

<Grass properties={grassyGeometryProperties} />
