<template>
  <div class="modal-overlay" @click.self="close">
    <div class="modal-content">
      <h2>{{ title }}</h2>
      <p>{{ message }}</p>
      <div class="modal-actions">
        <button @click="confirm">{{ confirmText }}</button>
        <button @click="close">{{ cancelText }}</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  title: String,
  message: String,
  confirmText: String,
  cancelText: String
});

const emit = defineEmits(['confirm', 'close']);

const confirm = () => {
  emit('confirm');
};

const close = () => {
  emit('close');
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: flex-start; /* Align items to the start (top) */
}

.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  max-width: 400px;
  width: 100%;
  margin-top: 25%; /* Position the modal 25% from the top */
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

button {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:first-of-type {
  background-color: #007bff;
  color: white;
}

button:last-of-type {
  background-color: #cccccc;
  color: black;
}
</style>