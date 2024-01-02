<script lang="ts">
	import { T } from '@threlte/core';
	import { Color } from 'three';

	import fragmentShader from '$lib/shaders/fragmentShader.glsl?raw';
	import vertexShader from '$lib/shaders/vertexShader.glsl?raw';

	const uniforms = {
		colorA: { value: new Color('#7CFC00') },
		colorB: { value: new Color('#000000') },
		density: { value: 100 }
	};

	const commonRotationX = -Math.PI / 2;
	const shellPadding = 0.01;
</script>

<T.Mesh rotation.x={commonRotationX}>
	<T.PlaneGeometry />
	<!-- <T.MeshStandardMaterial color="lawngreen" /> -->
	<T.ShaderMaterial {fragmentShader} {vertexShader} {uniforms} />
</T.Mesh>

<T.Mesh position.y={shellPadding} rotation.x={commonRotationX}>
	<T.PlaneGeometry />
	<!-- <T.MeshStandardMaterial color="lawngreen" /> -->
	<T.ShaderMaterial {fragmentShader} {vertexShader} {uniforms} />
</T.Mesh>
