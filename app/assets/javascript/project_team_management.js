// Project Team Management JavaScript
function initializeProjectTeamManagement() {
  // Developer Add/Remove
  const developerDropdown = document.getElementById('developer-dropdown');
  const addDeveloperBtn = document.getElementById('add-developer');
  const currentDevelopersDiv = document.getElementById('current-developers');
  const developerIdsContainer = document.getElementById('developer-ids-container');

  // QA Add/Remove
  const qaDropdown = document.getElementById('qa-dropdown');
  const addQaBtn = document.getElementById('add-qa');
  const currentQasDiv = document.getElementById('current-qas');
  const qaIdsContainer = document.getElementById('qa-ids-container');

  // Only initialize if elements exist (for project forms)
  if (developerDropdown && addDeveloperBtn) {
    addDeveloperBtn.addEventListener('click', function() {
      const selectedDeveloperId = developerDropdown.value;
      const selectedDeveloperName = developerDropdown.options[developerDropdown.selectedIndex].text;
      
      if (selectedDeveloperId && selectedDeveloperName !== 'Select Developer') {
        addDeveloper(selectedDeveloperId, selectedDeveloperName);
      }
    });

    addQaBtn.addEventListener('click', function() {
      const selectedQaId = qaDropdown.value;
      const selectedQaName = qaDropdown.options[qaDropdown.selectedIndex].text;
      
      if (selectedQaId && selectedQaName !== 'Select QA Tester') {
        addQa(selectedQaId, selectedQaName);
      }
    });

    // Initialize remove buttons for existing team members
    initializeExistingRemoveButtons();
  }
}

// Add Developer Function
function addDeveloper(developerId, developerName) {
  const currentDevelopersDiv = document.getElementById('current-developers');
  const developerIdsContainer = document.getElementById('developer-ids-container');
  const developerDropdown = document.getElementById('developer-dropdown');

  // Add to current developers display
  const developerDiv = document.createElement('div');
  developerDiv.className = 'd-flex justify-content-between align-items-center mb-1 p-2 border rounded';
  developerDiv.innerHTML = `
    <span>${developerName}</span>
    <button type="button" class="btn btn-sm btn-outline-danger remove-developer" data-user-id="${developerId}">
      Remove
    </button>
  `;
  
  if (!currentDevelopersDiv) {
    // Create current developers div if it doesn't exist
    const container = document.querySelector('.col-md-6:first-child .mb-2');
    const newCurrentDevsDiv = document.createElement('div');
    newCurrentDevsDiv.id = 'current-developers';
    newCurrentDevsDiv.className = 'mt-1';
    newCurrentDevsDiv.appendChild(developerDiv);
    container.appendChild(newCurrentDevsDiv);
    
    // Remove "No developers assigned" message
    const noDevMessage = container.querySelector('p.text-muted');
    if (noDevMessage) noDevMessage.remove();
  } else {
    currentDevelopersDiv.appendChild(developerDiv);
  }
  
  // Add hidden field
  const hiddenField = document.createElement('input');
  hiddenField.type = 'hidden';
  hiddenField.name = 'project[developer_ids][]';
  hiddenField.value = developerId;
  hiddenField.id = `developer_${developerId}`;
  developerIdsContainer.appendChild(hiddenField);
  
  // Remove from dropdown
  developerDropdown.remove(developerDropdown.selectedIndex);
  developerDropdown.value = '';
  
  // Add remove event listener
  developerDiv.querySelector('.remove-developer').addEventListener('click', function() {
    removeDeveloper(developerId, developerName, developerDiv);
  });
}

// Add QA Function
function addQa(qaId, qaName) {
  const currentQasDiv = document.getElementById('current-qas');
  const qaIdsContainer = document.getElementById('qa-ids-container');
  const qaDropdown = document.getElementById('qa-dropdown');

  // Add to current QAs display
  const qaDiv = document.createElement('div');
  qaDiv.className = 'd-flex justify-content-between align-items-center mb-1 p-2 border rounded';
  qaDiv.innerHTML = `
    <span>${qaName}</span>
    <button type="button" class="btn btn-sm btn-outline-danger remove-qa" data-user-id="${qaId}">
      Remove
    </button>
  `;
  
  if (!currentQasDiv) {
    // Create current QAs div if it doesn't exist
    const container = document.querySelector('.col-md-6:last-child .mb-2');
    const newCurrentQasDiv = document.createElement('div');
    newCurrentQasDiv.id = 'current-qas';
    newCurrentQasDiv.className = 'mt-1';
    newCurrentQasDiv.appendChild(qaDiv);
    container.appendChild(newCurrentQasDiv);
    
    // Remove "No QA testers assigned" message
    const noQaMessage = container.querySelector('p.text-muted');
    if (noQaMessage) noQaMessage.remove();
  } else {
    currentQasDiv.appendChild(qaDiv);
  }
  
  // Add hidden field
  const hiddenField = document.createElement('input');
  hiddenField.type = 'hidden';
  hiddenField.name = 'project[qa_ids][]';
  hiddenField.value = qaId;
  hiddenField.id = `qa_${qaId}`;
  qaIdsContainer.appendChild(hiddenField);
  
  // Remove from dropdown
  qaDropdown.remove(qaDropdown.selectedIndex);
  qaDropdown.value = '';
  
  // Add remove event listener
  qaDiv.querySelector('.remove-qa').addEventListener('click', function() {
    removeQa(qaId, qaName, qaDiv);
  });
}

// Remove Developer Function
function removeDeveloper(developerId, developerName, element) {
  element.remove();
  
  // Remove hidden field
  const hiddenField = document.getElementById(`developer_${developerId}`);
  if (hiddenField) hiddenField.remove();
  
  // Add back to dropdown
  const developerDropdown = document.getElementById('developer-dropdown');
  const option = document.createElement('option');
  option.value = developerId;
  option.textContent = developerName;
  developerDropdown.appendChild(option);
  
  // Check if no developers left
  const developerIdsContainer = document.getElementById('developer-ids-container');
  if (!developerIdsContainer.querySelector('input[type="hidden"]')) {
    const container = document.querySelector('.col-md-6:first-child .mb-2');
    const currentDevsDiv = document.getElementById('current-developers');
    if (currentDevsDiv) currentDevsDiv.remove();
    
    const noDevMessage = document.createElement('p');
    noDevMessage.className = 'text-muted small mt-1';
    noDevMessage.textContent = 'No developers assigned';
    container.appendChild(noDevMessage);
  }
}

// Remove QA Function
function removeQa(qaId, qaName, element) {
  element.remove();
  
  // Remove hidden field
  const hiddenField = document.getElementById(`qa_${qaId}`);
  if (hiddenField) hiddenField.remove();
  
  // Add back to dropdown
  const qaDropdown = document.getElementById('qa-dropdown');
  const option = document.createElement('option');
  option.value = qaId;
  option.textContent = qaName;
  qaDropdown.appendChild(option);
  
  // Check if no QAs left
  const qaIdsContainer = document.getElementById('qa-ids-container');
  if (!qaIdsContainer.querySelector('input[type="hidden"]')) {
    const container = document.querySelector('.col-md-6:last-child .mb-2');
    const currentQasDiv = document.getElementById('current-qas');
    if (currentQasDiv) currentQasDiv.remove();
    
    const noQaMessage = document.createElement('p');
    noQaMessage.className = 'text-muted small mt-1';
    noQaMessage.textContent = 'No QA testers assigned';
    container.appendChild(noQaMessage);
  }
}

// Initialize remove buttons for existing team members
function initializeExistingRemoveButtons() {
  document.querySelectorAll('.remove-developer').forEach(btn => {
    btn.addEventListener('click', function() {
      const developerId = this.getAttribute('data-user-id');
      const developerName = this.parentElement.querySelector('span').textContent;
      removeDeveloper(developerId, developerName, this.parentElement);
    });
  });

  document.querySelectorAll('.remove-qa').forEach(btn => {
    btn.addEventListener('click', function() {
      const qaId = this.getAttribute('data-user-id');
      const qaName = this.parentElement.querySelector('span').textContent;
      removeQa(qaId, qaName, this.parentElement);
    });
  });
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  initializeProjectTeamManagement();
});

// Export for potential module usage
export { initializeProjectTeamManagement, addDeveloper, addQa, removeDeveloper, removeQa };