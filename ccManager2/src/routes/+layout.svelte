<script>
	import '../app.css';
	import { page } from '$app/state';
	let { children } = $props();

	const navItems = [
		{ name: 'Dashboard', href: '/', icon: '📊' },
		{ name: 'Computers', href: '/computers', icon: '💻' },
		{ name: 'Instructions', href: '/instructions', icon: '📜' },
		{ name: 'Data Lists', href: '/lists', icon: '📋' }
	];
</script>

<div class="app-container">
	<aside class="sidebar">
		<div class="logo">
			<span class="logo-icon">💠</span>
			<span class="logo-text">CC Manager</span>
		</div>
		
		<nav>
			{#each navItems as item}
				<a 
					href={item.href} 
					class="nav-item" 
					class:active={page.url.pathname === item.href}
				>
					<span class="icon">{item.icon}</span>
					<span class="label">{item.name}</span>
				</a>
			{/each}
		</nav>

		<div class="sidebar-footer">
			<div class="user-info">
				<div class="avatar">👤</div>
				<div class="details">
					<span class="username">Terence</span>
					<span class="role">Admin</span>
				</div>
			</div>
		</div>
	</aside>

	<main class="content">
		{@render children()}
	</main>
</div>

<style>
	.app-container {
		display: flex;
		min-height: 100vh;
	}

	.sidebar {
		width: 280px;
		background: var(--bg-sidebar);
		backdrop-filter: blur(20px);
		border-right: 1px solid var(--glass-border);
		padding: 2rem 1.5rem;
		display: flex;
		flex-direction: column;
		position: sticky;
		top: 0;
		height: 100vh;
	}

	.logo {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		margin-bottom: 3rem;
		padding: 0 0.5rem;
	}

	.logo-icon {
		font-size: 1.5rem;
		filter: drop-shadow(0 0 8px var(--accent-primary));
	}

	.logo-text {
		font-family: 'Outfit', sans-serif;
		font-size: 1.25rem;
		font-weight: 700;
		letter-spacing: -0.02em;
	}

	nav {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.nav-item {
		display: flex;
		align-items: center;
		gap: 1rem;
		padding: 0.875rem 1rem;
		border-radius: 0.75rem;
		text-decoration: none;
		color: var(--text-muted);
		transition: all 0.2s;
	}

	.nav-item:hover {
		background: rgba(255, 255, 255, 0.05);
		color: var(--text-main);
	}

	.nav-item.active {
		background: rgba(59, 130, 246, 0.1);
		color: var(--accent-primary);
		border: 1px solid rgba(59, 130, 246, 0.2);
	}

	.sidebar-footer {
		margin-top: auto;
		padding-top: 2rem;
		border-top: 1px solid var(--glass-border);
	}

	.user-info {
		display: flex;
		align-items: center;
		gap: 1rem;
		padding: 0.5rem;
	}

	.avatar {
		width: 40px;
		height: 40px;
		background: var(--glass);
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		border: 1px solid var(--glass-border);
	}

	.details {
		display: flex;
		flex-direction: column;
	}

	.username {
		font-weight: 600;
		font-size: 0.875rem;
	}

	.role {
		font-size: 0.75rem;
		color: var(--text-muted);
	}

	.content {
		flex: 1;
		padding: 2.5rem;
		max-width: 1400px;
		margin: 0 auto;
		width: 100%;
	}
</style>
