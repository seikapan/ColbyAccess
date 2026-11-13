import { useEffect, useState } from 'react'
import './App.css'

type ServiceStatus = 'checking' | 'connected' | 'unavailable'

function App() {
  const [serviceStatus, setServiceStatus] = useState<ServiceStatus>('checking')

  useEffect(() => {
    async function checkService() {
      try {
        const response = await fetch('/api/health')
        setServiceStatus(response.ok ? 'connected' : 'unavailable')
      } catch {
        setServiceStatus('unavailable')
      }
    }

    void checkService()
  }, [])

  return (
    <main>
      <p className="eyebrow">Colby Access</p>
      <h1>Application foundation is ready.</h1>
      <p className="summary">
        The client, API, and local PostgreSQL service are connected. The domain schema and handwritten data can be added once the ER diagram is available.
      </p>
      <section aria-label="Service status">
        <p>API and database</p>
        <strong data-status={serviceStatus}>{serviceStatus}</strong>
      </section>
    </main>
  )
}

export default App
