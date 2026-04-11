<script lang="ts">
	let { data } = $props();

	function getTimeAgo(date: Date) {
		const seconds = Math.floor((new Date().getTime() - new Date(date).getTime()) / 1000);
		if (seconds < 60) return 'Just now';
		const minutes = Math.floor(seconds / 60);
		if (minutes < 60) return `${minutes}m ago`;
		const hours = Math.floor(minutes / 60);
		if (hours < 24) return `${hours}h ago`;
		return new Date(date).toLocaleDateString();
	}

	function isOnline(date: Date) {
		return (new Date().getTime() - new Date(date).getTime()) < 5 * 60 * 1000;
	}
</script>

<header class="page-header">
	<h1>Computers & Turtles</h1>
	<p class="subtitle">Manage and monitor all devices in your network</p>
</header>

<div class="glass-card table-container">
	<table>
		<thead>
			<tr>
				<th>ID</th>
				<th>Label</th>
				<th>Type</th>
				<th>Status</th>
				<th>Last Seen</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
			{#each data.computers as comp}
				<tr>
					<td><span class="id-badge">#{comp.computerId}</span></td>
					<td><span class="label-text">{comp.label}</span></td>
					<td><span class="type-pill">{comp.type}</span></td>
					<td>
						<span class="badge {isOnline(comp.lastSeen) ? 'badge-online' : 'badge-offline'}">
							{isOnline(comp.lastSeen) ? 'Online' : 'Offline'}
						</span>
					</td>
					<td>{getTimeAgo(comp.lastSeen)}</td>
					<td>
						<button class="action-btn" title="View Logs">📊</button>
						<button class="action-btn" title="Edit Label">✏️</button>
					</td>
				</tr>
			{:else}
				<tr>
					<td colspan="6" class="empty">No devices registered.</td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>

<style>
	.page-header { margin-bottom: 2rem; }
	.table-container { padding: 0; }
	table { width: 100%; border-collapse: collapse; }
	th { 
		text-align: left; 
		padding: 1rem 1.5rem; 
		font-size: 0.75rem; 
		color: var(--text-muted); 
		border-bottom: 1px solid var(--glass-border);
		background: rgba(255, 255, 255, 0.01);
	}
	td { padding: 1rem 1.5rem; border-bottom: 1px solid var(--glass-border); }
	.id-badge { font-family: monospace; color: var(--accent-primary); font-weight: 700; }
	.label-text { font-weight: 600; }
	.type-pill { 
		background: rgba(255, 255, 255, 0.05); 
		padding: 0.2rem 0.6rem; 
		border-radius: 2rem; 
		font-size: 0.75rem; 
		text-transform: capitalize;
	}
	.empty { text-align: center; padding: 4rem; color: var(--text-muted); }
	.action-btn {
		background: none;
		border: 1px solid var(--glass-border);
		border-radius: 0.5rem;
		padding: 0.4rem;
		cursor: pointer;
		transition: all 0.2s;
		filter: grayscale(1);
		margin-right: 0.5rem;
	}
	.action-btn:hover { background: rgba(255, 255, 255, 0.1); filter: grayscale(0); border-color: white; }
</style>
