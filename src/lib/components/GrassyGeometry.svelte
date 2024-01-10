<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { Color, SphereGeometry, Vector3 } from 'three';

	import fragmentShader from '$lib/shaders/grass/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/grass/vertexShader.glsl?raw';

	import type { GrassyGeometryProperties } from '$lib/types/GrassyGeometry';

	export let properties: GrassyGeometryProperties;

	let rotationSpeed = 0;
	$: {
		rotationSpeed = properties.rotationSpeed;
	}

	let delta = 0;
	useTask((diff) => {
		delta += diff;
	});

	let defaultUniforms: Record<string, { value: any }> = {
		ambientOcclusionAttenuation: { value: properties.ambientOcclusionAttenuation },
		ambientOcclusionBias: { value: properties.ambientOcclusionBias },
		color: { value: new Color(properties.color) },
		density: { value: properties.density },
		lightDirection: { value: properties.lightDirection },
		noiseMax: { value: properties.noiseMax },
		noiseMin: { value: properties.noiseMin },
		shellCount: { value: properties.shellCount },
		shellCurvature: { value: properties.shellCurvature },
		shellLength: { value: properties.shellLength },
		shellThickness: { value: properties.shellThickness },
		time: { value: delta },
		windSpeed: { value: properties.windSpeed },
		windStrength: { value: properties.windStrength }
	};

	$: {
		Object.keys(properties).forEach((key) => {
			if (!(key in defaultUniforms)) return;

			const incomingValue = properties[key as keyof GrassyGeometryProperties];

			if (key === 'color') {
				if (typeof incomingValue !== 'string') {
					console.warn('GrassyGeometry: color must be a string');
					return;
				}
				defaultUniforms[key].value.set(new Color(incomingValue));
			} else if (key === 'lightDirection') {
				if (!(incomingValue instanceof Vector3)) {
					console.warn('GrassyGeometry: lightDirection must be a Vector3');
					return;
				}
				defaultUniforms[key].value = new Vector3(incomingValue.x, incomingValue.y, incomingValue.z);
			} else {
				defaultUniforms[key].value = properties[key as keyof GrassyGeometryProperties];
			}
		});
	}
</script>

{#each Array(properties.shellCount) as _, shellIndex}
	<T.Mesh rotation.y={delta * 0}>
		<T.SphereGeometry />
		<T.ShaderMaterial
			{fragmentShader}
			{vertexShader}
			uniforms={{
				...defaultUniforms,
				shellIndex: { value: shellIndex + 1 }
			}}
			uniforms.time.value={delta}
		/>
	</T.Mesh>
{/each}
