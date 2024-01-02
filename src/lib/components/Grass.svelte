<script lang="ts">
	import { T } from '@threlte/core';
	import { Color } from 'three';

	import fragmentShader from '$lib/shaders/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/vertexShader.glsl?raw';

	const uniforms = {
		color: { value: new Color('#7CFC00') },
		density: { value: 100 },
		shellIndex: { value: 0 }
	};

	const commonRotationX = -Math.PI / 2;

	const shellCount = 16;
	const shellPadding = 0.005;
</script>

{#each Array(shellCount) as _, i}
	<T.Mesh position.y={shellPadding * i} rotation.x={commonRotationX}>
		<T.PlaneGeometry />
		<T.ShaderMaterial
			{fragmentShader}
			{vertexShader}
			uniforms={{ ...uniforms, shellIndex: { value: i } }}
		/>
	</T.Mesh>
{/each}
