<script lang="ts">
	let { data } = $props();
	let showNewForm = $state(false);
	let newVersion = $state('');
	let newBody = $state('');
	let isSubmitting = $state(false);

	async function handleSubmit(e: SubmitEvent) {
		e.preventDefault();
		isSubmitting = true;
		
		try {
			const res = await fetch('/api/instructions', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ version: newVersion, body: newBody })
			});
			
			if (res.ok) {
				location.reload(); // Simple refresh for now
			}
		} finally {
			isSubmitting = false;
		}
	}
</script>

<header class="page-header">
	<div class="header-main">
		<h1>Instructions</h1>
		<button class="btn-primary" onclick={() => showNewForm = !showNewForm}>
			{showNewForm ? 'Cancel' : 'New Version'}
		</button>
	</div>
	<p class="subtitle">Manage logic and scripts for your CC turtles</p>
</header>

{#if showNewForm}
	<form class="glass-card new-form" onsubmit={handleSubmit}>
		<div class="form-group">
			<label for="version">Version Number</label>
			<input 
				id="version" 
				type="text" 
				bind:value={newVersion} 
				placeholder="e.g. 1.0.4"
				required
			/>
		</div>
		<div class="form-group">
			<label for="body">Instruction Script</label>
			<textarea 
				id="body" 
				bind:value={newBody} 
				placeholder="Paste your Lua script or instructions here..."
				rows="10"
				required
			></textarea>
		</div>
		<button type="submit" class="btn-primary" disabled={isSubmitting}>
			{isSubmitting ? 'Saving...' : 'Deploy Version'}
		</button>
	</form>
{/if}

<div class="instructions-list">
	{#each data.instructions as instr}
		<article class="glass-card instr-card">
			<div class="instr-header">
				<div class="instr-meta">
					<span class="version-badge">v{instr.version}</span>
					<span class="date">{new Date(instr.updatedAt).toLocaleString()}</span>
				</div>
			</div>
			<div class="instr-body">
				<pre><code>{instr.body}</code></pre>
			</div>
		</article>
	{:else}
		<div class="empty-state">
			No instructions found. Create your first version to get started.
		</div>
	{/each}
</div>

<style>
	.page-header { margin-bottom: 2rem; }
	.header-main { display: flex; justify-content: space-between; align-items: center; }
	
	.new-form {
		margin-bottom: 3rem;
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		animation: slideDown 0.3s ease-out;
	}

	@keyframes slideDown {
		from { opacity: 0; transform: translateY(-20px); }
		to { opacity: 1; transform: translateY(0); }
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	label { font-weight: 600; font-size: 0.875rem; color: var(--text-muted); }

	input, textarea {
		background: rgba(0, 0, 0, 0.2);
		border: 1px solid var(--glass-border);
		border-radius: 0.5rem;
		padding: 0.75rem 1rem;
		color: white;
		font-family: inherit;
		outline: none;
	}

	input:focus, textarea:focus { border-color: var(--accent-primary); }

	textarea { font-family: 'Inter', monospace; font-size: 0.875rem; }

	.instructions-list { display: flex; flex-direction: column; gap: 1.5rem; }

	.instr-card { padding: 0; overflow: hidden; }

	.instr-header {
		padding: 1rem 1.5rem;
		background: rgba(255, 255, 255, 0.02);
		border-bottom: 1px solid var(--glass-border);
	}

	.instr-meta { display: flex; align-items: center; gap: 1rem; }

	.version-badge {
		background: var(--accent-secondary);
		color: white;
		padding: 0.2rem 0.6rem;
		border-radius: 0.4rem;
		font-weight: 700;
		font-size: 0.8rem;
	}

	.date { font-size: 0.8rem; color: var(--text-muted); }

	.instr-body {
		padding: 1.5rem;
		max-height: 400px;
		overflow-y: auto;
		background: #000;
	}

	pre { margin: 0; }
	code { font-family: 'Fira Code', 'Roboto Mono', monospace; font-size: 0.875rem; line-height: 1.6; color: #9cdcfe; }

	.empty-state { text-align: center; padding: 4rem; color: var(--text-muted); }
</style>
