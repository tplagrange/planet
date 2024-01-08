<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { Color, SphereGeometry, Vector3 } from 'three';

	import fragmentShader from '$lib/shaders/grass/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/grass/vertexShader.glsl?raw';

	import type { GrassyGeometryProperties } from '$lib/types/GrassyGeometry';

	export let properties: GrassyGeometryProperties;

	let defaultUniforms: Record<string, { value: any }> = {
		color: { value: new Color(properties.color) },
		density: { value: properties.density },
		lightDirection: { value: properties.lightDirection },
		noiseMax: { value: properties.noiseMax },
		noiseMin: { value: properties.noiseMin },
		shellCount: { value: properties.shellCount },
		shellIndex: { value: 0 },
		shellLength: { value: properties.shellLength },
		shellThickness: { value: properties.shellThickness }
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

	const isSphere = true;

	const geometry = new SphereGeometry();

	const windSpeed = 1;

	let delta = 0;
	useTask((diff) => (delta += diff));
</script>

{#each Array(properties.shellCount) as _, shellIndex}
	<T.Mesh rotation.y={delta * 0.025}>
		{#if isSphere}
			<T is={geometry} />
		{:else}
			<T.PlaneGeometry />
		{/if}
		<T.ShaderMaterial
			{fragmentShader}
			{vertexShader}
			uniforms={{
				...defaultUniforms,
				time: { value: 0 },
				shellIndex: { value: shellIndex + 1 }
			}}
			uniforms.time.value={delta * windSpeed}
		/>
	</T.Mesh>
{/each}
