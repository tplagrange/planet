<script lang="ts">
	import { T } from '@threlte/core';

	import fragmentShader from '$lib/shaders/atmosphere/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/atmosphere/vertexShader.glsl?raw';
	import { AdditiveBlending, BackSide, Color } from 'three';

	export let properties: AtmosphereProperties;

	let defaultUniforms: Record<string, { value: any }> = {
		color: { value: new Color(properties.color) },
		intensity: { value: properties.intensity }
	};

	$: {
		Object.keys(properties).forEach((key) => {
			if (!(key in defaultUniforms)) return;

			const incomingValue = properties[key as keyof AtmosphereProperties];

			if (key === 'color') {
				if (typeof incomingValue !== 'string') {
					console.warn('GrassyGeometry: color must be a string');
					return;
				}
				defaultUniforms[key].value.set(new Color(incomingValue));
			} else {
				defaultUniforms[key].value = properties[key as keyof AtmosphereProperties];
			}
		});
	}
</script>

<T.Mesh scale={properties.scale}>
	<T.SphereGeometry />
	<T.ShaderMaterial
		{fragmentShader}
		{vertexShader}
		uniforms={{
			...defaultUniforms
		}}
		blending={AdditiveBlending}
		side={BackSide}
	/>
</T.Mesh>
