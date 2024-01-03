<script lang="ts">
	import { T } from '@threlte/core';
	import { OrbitControls } from '@threlte/extras';
	import Grass from './GrassyGeometry.svelte';

	import GUI from 'lil-gui';

	const settingsToPropertiesMap: Map<keyof GrassyGeometrySettings, keyof GrassyGeometryProperties> =
		new Map([
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

			properties[property] = settings[key as keyof GrassyGeometrySettings];
		});

		return properties as GrassyGeometryProperties;
	};

	const defaultSettings: GrassyGeometrySettings = {
		'Grass Color': '#7CFC00',
		'Noise Max': 1.0,
		'Noise Min': 0.6,
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
	};

	createPanel(defaultSettings);
</script>

<T.PerspectiveCamera makeDefault position={[3, 10, 0]} fov={15}>
	<OrbitControls autoRotate={false} enableDamping autoRotateSpeed={0.5} />
</T.PerspectiveCamera>

<Grass properties={grassyGeometryProperties} />
