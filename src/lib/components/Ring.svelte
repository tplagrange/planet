<script lang="ts">
	import { T } from '@threlte/core';

	const radius = 2.5;
	const tube = 0.1;

	const planetaryTitle = Math.PI / 12;
</script>

<T.Mesh rotation.x={Math.PI / 2} rotation.y={planetaryTitle}>
	<T.TorusGeometry args={[radius, tube]} />
	<T.MeshBasicMaterial color="red" />
</T.Mesh>
