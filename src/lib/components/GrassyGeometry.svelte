<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { BoxGeometry, Color, IcosahedronGeometry, Sphere, SphereGeometry, Vector3 } from 'three';

	import fragmentShader from '$lib/shaders/grass/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/grass/vertexShader.glsl?raw';

	import type { GrassyGeometryProperties } from '$lib/types/GrassyGeometry';

	export let properties: GrassyGeometryProperties;

	let uniforms: Record<string, { value: any }> = {
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
		// uniforms.color.value.set(new Color(properties.color));
		Object.keys(properties).forEach((key) => {
			if (!(key in uniforms)) return;

			const incomingValue = properties[key as keyof GrassyGeometryProperties];

			if (key === 'color') {
				if (typeof incomingValue !== 'string') {
					console.warn('GrassyGeometry: color must be a string');
					return;
				}
				uniforms[key].value.set(new Color(incomingValue));
			} else if (key === 'lightDirection') {
				if (!(incomingValue instanceof Vector3)) {
					console.warn('GrassyGeometry: lightDirection must be a Vector3');
					return;
				}
				uniforms[key].value = new Vector3(incomingValue.x, incomingValue.y, incomingValue.z);
			} else {
				uniforms[key].value = properties[key as keyof GrassyGeometryProperties];
			}
		});
	}

	const isSphere = true;
	let rotation = 0;
	useTask((delta) => (rotation += delta * 0.025));
</script>

{#each Array(properties.shellCount) as _, shellIndex}
	<T.Mesh rotation.x={rotation}>
		{#if isSphere}
			<T.SphereGeometry />
		{:else}
			<T.PlaneGeometry />
		{/if}
		<T.ShaderMaterial
			{fragmentShader}
			{vertexShader}
			uniforms={{ ...uniforms, shellIndex: { value: shellIndex + 1 } }}
		/>
	</T.Mesh>
{/each}
