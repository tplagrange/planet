<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { Color } from 'three';

	import fragmentShader from '$lib/shaders/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/vertexShader.glsl?raw';

	export let properties: GrassyGeometryProperties;

	let uniforms: Record<string, { value: any }> = {
		color: { value: new Color(properties.color) },
		density: { value: properties.density },
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

			if (key === 'color') {
				uniforms[key].value.set(new Color(properties[key as keyof GrassyGeometryProperties]));
			} else {
				uniforms[key].value = properties[key as keyof GrassyGeometryProperties];
			}
		});
	}

	const isSphere = true;
	let rotation = 0;
	useTask((delta) => (rotation += delta * 0.025));

	console.log(uniforms);
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
