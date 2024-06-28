// Configuração do Firebase
const firebaseConfig = {
  apiKey: 'AIzaSyCkUldRq3rk-Ac_Fno_dtCL5P24W6VCmbQ',
  appId: '1:581039158937:web:27aabdb75c638250122a08',
  messagingSenderId: '581039158937',
  projectId: 'projetoaplicado-2f74d',
  authDomain: 'projetoaplicado-2f74d.firebaseapp.com',
  storageBucket: 'projetoaplicado-2f74d.appspot.com',
};

// Inicialização do Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
const storage = firebase.storage();

async function validateCode() {
  const code = document.getElementById('codeInput').value;
  try {
    const querySnapshot = await db.collection('Users').where('code', '==', code).get();
    if (!querySnapshot.empty) {
      // Código válido: exibir dados do usuário
      const userDoc = querySnapshot.docs[0];
      const userData = userDoc.data();
      document.getElementById('userInfo').innerHTML = `
          <p>Nome: ${userData.name}</p>
          <p>Email: ${userData.email}</p>
          <p>Contato: ${userData.phone}</p>
          <p>Idade: ${userData.age}</p>
          <p>Altura: ${userData.height} cm</p>
          <p>Doa Sangue: ${userData.bloodDonor ? 'Sim' : 'Não'}</p>
          <p>Tipo Sanguíneo: ${userData.bloodType}</p>
          <p>Doador de Órgãos: ${userData.organDonor ? 'Sim' : 'Não'}</p>
          <p>Dependentes: ${userData.dependents.join(", ")}</p>
      `;
      document.getElementById('userPhoto').src = userData.profile_picture || 'default_user.png';
      const userId = userDoc.id;
      await fetchAdditionalInfo(userId);

      // Adicionar classe para expandir #userInfo
      document.getElementById('userInfo').classList.add('showUserInfo');

      // Limpar mensagem de código inválido se houver
      document.getElementById('userData').innerText = '';
    } else {
      // Código inválido: manter mensagem de boas-vindas e imagem do usuário
      // Não alterar #userInfo e #userPhoto neste caso
      document.getElementById('userData').innerText = 'Código inválido';
      document.getElementById('additionalInfo').innerHTML = ''; // Limpar dados adicionais se houver

      // Remover classe para reduzir #userInfo
      document.getElementById('userInfo').classList.remove('showUserInfo');
    }
  } catch (error) {
    console.error('Erro ao validar o código:', error);
    document.getElementById('userData').innerText = `Erro ao validar o código: ${error.message}`;
  }
}




async function fetchAdditionalInfo(userId) {
  try {
      const atestadosSnapshot = await db.collection('Atestados').where('userId', '==', userId).get();
      const vacinasSnapshot = await db.collection('Vacinas').where('userId', '==', userId).get();
      const examesSnapshot = await db.collection('Exames').where('userId', '==', userId).get();
      const consultaSnapshot = await db.collection('Consultas').where('userId', '==', userId).get();

      let atestadosHTML = '<h3>Atestados</h3><ul>';
      atestadosSnapshot.forEach(doc => {
          const data = doc.data();
          atestadosHTML += `<li>${data.nomeMedico} - ${data.dataEmissao} - ${data.quantidadeDias} dia(s)<br>
          <a href="#" onclick="openDocument('${data.arquivoUrl}')">Ver Documento</a></li>`;
      });
      atestadosHTML += '</ul>';

      let vacinasHTML = '<h3>Vacinas</h3><ul>';
      vacinasSnapshot.forEach(doc => {
          const data = doc.data();
          vacinasHTML += `<li>${data.tipo} - ${data.dateAplicacao} - ${data.numeroLote || "Sem lote"}<br>
          <a href="#" onclick="openDocument('${data.arquivoUrl}')">Ver Documento</a></li>`;
      });
      vacinasHTML += '</ul>';

      let examesHTML = '<h3>Exames</h3><ul>';
      examesSnapshot.forEach(doc => {
          const data = doc.data();
          examesHTML += `<li>${data.tipo} - ${data.laudo} - ${data.date}<br>
          <a href="#" onclick="openDocument('${data.arquivoUrl}')">Ver Documento</a></li>`;
      });
      examesHTML += '</ul>';

      let consultasHTML = '<h3>Consultas</h3><ul>';
      consultaSnapshot.forEach(doc => {
        const data = doc.data();
        consultasHTML += `<li>${data.areaMedica} - ${data.date} - ${data.descricao}<br></li>`;
      });
      consultasHTML += '</ul>';
  
      document.getElementById('additionalInfo').innerHTML = `${atestadosHTML} ${vacinasHTML} ${examesHTML} ${consultasHTML}`;
  } catch (error) {
      console.error('Erro ao buscar informações adicionais:', error);
      document.getElementById('additionalInfo').innerText = `Erro ao buscar informações adicionais: ${error.message}`;
  }
}

function openDocument(url) {
  const fileName = url.split('?')[0]; // Remove query parameters
  const fileType = fileName.split('.').pop().toLowerCase();
  console.log(`Opening document. URL: ${url}, FileType: ${fileType}`);
  if (fileType === 'pdf') {
      openPdf(url);
  } else {
      openModal(url);
  }
}

function openPdf(pdfUrl) {
  console.log(`Loading PDF: ${pdfUrl}`);
  const viewer = document.getElementById('pdfViewer');
  viewer.src = `https://docs.google.com/gview?url=${encodeURIComponent(pdfUrl)}&embedded=true`;

  document.getElementById('modalImage').style.display = 'none';
  viewer.style.display = 'block';
  document.getElementById('imageModal').style.display = 'block';
}

function openModal(imageUrl) {
  console.log(`Loading image: ${imageUrl}`);
  document.getElementById('modalImage').src = imageUrl;
  document.getElementById('modalImage').style.display = 'block';
  document.getElementById('pdfViewer').style.display = 'none';
  document.getElementById('imageModal').style.display = 'block';
}

function closeModal() {
  document.getElementById('imageModal').style.display = 'none';
}
