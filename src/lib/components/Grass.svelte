<script lang="ts">
	import { T } from '@threlte/core';
	import { Color } from 'three';

	import fragmentShader from '$lib/shaders/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/vertexShader.glsl?raw';

	const commonRotationX = -Math.PI / 2;

	const shellCount = 256;
	const shellLength = 0.05;

	const uniforms = {
		color: { value: new Color('#7CFC00') },
		density: { value: 256 },
		shellCount: { value: shellCount },
		shellIndex: { value: 0 },
		shellLength: { value: shellLength }
	};
</script>

{#each Array(shellCount) as _, shellIndex}
	<T.Mesh rotation.x={commonRotationX}>
		<!-- <T.SphereGeometry /> -->
		<T.PlaneGeometry />
		<T.ShaderMaterial
			{fragmentShader}
			{vertexShader}
			uniforms={{ ...uniforms, shellIndex: { value: shellIndex + 1 } }}
		/>
	</T.Mesh>
{/each}
