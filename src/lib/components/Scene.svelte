<script lang="ts">
	import { T } from '@threlte/core';
	import { ContactShadows, Float, Grid, OrbitControls } from '@threlte/extras';
	import Grass from './Grass.svelte';
</script>

<T.PerspectiveCamera makeDefault position={[3, 10, 0]} fov={15}>
	<OrbitControls autoRotate={false} enableDamping autoRotateSpeed={0.5} />
</T.PerspectiveCamera>

<Grass />
