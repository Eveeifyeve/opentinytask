<script lang="ts">
 import CheckIcon from "@lucide/svelte/icons/check";
 import ChevronsUpDownIcon from "@lucide/svelte/icons/chevrons-up-down";
 import { tick } from "svelte";
 import * as Command from "$lib/components/ui/command/index.js";
 import * as Popover from "$lib/components/ui/popover/index.js";
 import { Button } from "$lib/components/ui/button/index.js";
 import { cn } from "$lib/utils.js";
 
 const frameworks = [
  {
   value: "sveltekit",
   label: "SvelteKit",
  },
  {
   value: "next.js",
   label: "Next.js",
  },
  {
   value: "nuxt.js",
   label: "Nuxt.js",
  },
  {
   value: "remix",
   label: "Remix",
  },
  {
   value: "astro",
   label: "Astro",
  },
 ];
 
 let open = $state(false);
 let value = $state("");
 let triggerRef = $state<HTMLButtonElement>(null!);
 
 const selectedValue = $derived(
  frameworks.find((f) => f.value === value)?.label
 );
 
 // We want to refocus the trigger button when the user selects
 // an item from the list so users can continue navigating the
 // rest of the form with the keyboard.
 function closeAndFocusTrigger() {
  open = false;
  tick().then(() => {
   triggerRef.focus();
  });
 }
</script>

<main class="container">
<Popover.Root bind:open>
 <Popover.Trigger bind:ref={triggerRef}>
  {#snippet child({ props })}
   <Button
    variant="outline"
    class="w-[200px] justify-between"
    {...props}
    role="combobox"
    aria-expanded={open}
   >
    {selectedValue || "Select a framework..."}
    <ChevronsUpDownIcon class="ml-2 size-4 shrink-0 opacity-50" />
   </Button>
  {/snippet}
 </Popover.Trigger>
 <Popover.Content class="w-[200px] p-0">
  <Command.Root>
   <Command.Input placeholder="Search framework..." />
   <Command.List>
    <Command.Empty>No framework found.</Command.Empty>
    <Command.Group>
     {#each frameworks as framework}
      <Command.Item
       value={framework.value}
       onSelect={() => {
        value = framework.value;
        closeAndFocusTrigger();
       }}
      >
       <CheckIcon
        class={cn(
         "mr-2 size-4",
         value !== framework.value && "text-transparent"
        )}
       />
       {framework.label}
      </Command.Item>
     {/each}
    </Command.Group>
   </Command.List>
  </Command.Root>
 </Popover.Content>
</Popover.Root>
</main>
