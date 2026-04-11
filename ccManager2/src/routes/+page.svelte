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
	<h1>Dashboard</h1>
	<p class="subtitle">Overview of your ComputerCraft network</p>
</header>

<div class="stats-grid">
	<div class="glass-card stat-card">
		<span class="stat-icon">💻</span>
		<div class="stat-content">
			<span class="stat-label">Total Devices</span>
			<span class="stat-value">{data.stats.total}</span>
		</div>
	</div>
	<div class="glass-card stat-card">
		<span class="stat-icon" style="color: #4ade80">⚡</span>
		<div class="stat-content">
			<span class="stat-label">Online Now</span>
			<span class="stat-value">{data.stats.online}</span>
		</div>
	</div>
	<div class="glass-card stat-card">
		<span class="stat-icon" style="color: #8b5cf6">📜</span>
		<div class="stat-content">
			<span class="stat-label">Logic Version</span>
			<span class="stat-value">{data.stats.latestVersion}</span>
		</div>
	</div>
</div>

<section class="recent-section">
	<div class="section-header">
		<h2>Recent Activity</h2>
		<a href="/computers" class="view-all">View All</a>
	</div>

	<div class="glass-card table-container">
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Label</th>
					<th>Type</th>
					<th>Status</th>
					<th>Last Seen</th>
				</tr>
			</thead>
			<tbody>
				{#each data.recentComputers as comp}
					<tr>
						<td><code class="id-badge">#{comp.computerId}</code></td>
						<td>{comp.label}</td>
						<td><span class="type-badge">{comp.type}</span></td>
						<td>
							<span class="badge {isOnline(comp.lastSeen) ? 'badge-online' : 'badge-offline'}">
								{isOnline(comp.lastSeen) ? 'Online' : 'Offline'}
							</span>
						</td>
						<td class="text-muted">{getTimeAgo(comp.lastSeen)}</td>
					</tr>
				{/each}
				{#if data.recentComputers.length === 0}
					<tr>
						<td colspan="5" style="text-align: center; padding: 3rem; color: var(--text-muted);">
							No computers registered yet.
						</td>
					</tr>
				{/if}
			</tbody>
		</table>
	</div>
</section>

<style>
	.page-header {
		margin-bottom: 3rem;
	}

	h1 {
		font-size: 2.5rem;
		margin: 0;
		background: linear-gradient(135deg, #fff 0%, #94a3b8 100%);
		background-clip: text;
		-webkit-background-clip: text;
		-webkit-text-fill-color: transparent;
	}

	.subtitle {
		color: var(--text-muted);
		margin-top: 0.5rem;
	}

	.stats-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
		gap: 1.5rem;
		margin-bottom: 4rem;
	}

	.stat-card {
		display: flex;
		align-items: center;
		gap: 1.5rem;
		transition: transform 0.3s;
	}

	.stat-card:hover {
		transform: translateY(-5px);
		border-color: var(--accent-primary);
	}

	.stat-icon {
		font-size: 2.5rem;
		background: rgba(255, 255, 255, 0.05);
		width: 64px;
		height: 64px;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 1rem;
	}

	.stat-content {
		display: flex;
		flex-direction: column;
	}

	.stat-label {
		color: var(--text-muted);
		font-size: 0.875rem;
		font-weight: 500;
	}

	.stat-value {
		font-size: 1.75rem;
		font-weight: 700;
		font-family: 'Outfit', sans-serif;
	}

	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1.5rem;
	}

	.view-all {
		color: var(--accent-primary);
		text-decoration: none;
		font-size: 0.875rem;
		font-weight: 600;
	}

	.table-container {
		padding: 0;
		overflow: hidden;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		text-align: left;
	}

	th {
		background: rgba(255, 255, 255, 0.02);
		padding: 1rem 1.5rem;
		font-size: 0.75rem;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-muted);
		border-bottom: 1px solid var(--glass-border);
	}

	td {
		padding: 1.25rem 1.5rem;
		border-bottom: 1px solid var(--glass-border);
	}

	tr:last-child td {
		border-bottom: none;
	}

	tr:hover td {
		background: rgba(255, 255, 255, 0.01);
	}

	.id-badge {
		background: rgba(59, 130, 246, 0.1);
		color: var(--accent-primary);
		padding: 0.25rem 0.5rem;
		border-radius: 0.25rem;
		font-family: monospace;
	}

	.type-badge {
		background: rgba(255, 255, 255, 0.05);
		padding: 0.25rem 0.625rem;
		border-radius: 0.5rem;
		font-size: 0.875rem;
	}
</style>
