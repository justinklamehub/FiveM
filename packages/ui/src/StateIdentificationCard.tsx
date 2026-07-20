/** Displays a server-validated State ID to its holder or a nearby player. */
import type { StateIdentificationPresentation } from '@cnr/contracts';

interface StateIdentificationCardProps {
  presentation: StateIdentificationPresentation;
  onClose: () => void;
}

export function StateIdentificationCard({ presentation, onClose }: StateIdentificationCardProps) {
  const { document } = presentation;
  return (
    <main className="nui-stage identity-stage" aria-label="State identification">
      <section className="identity-card" role="dialog" aria-modal="true">
        <header className="identity-card__header">
          <div className="identity-card__seal">SA</div>
          <div>
            <span>State of San Andreas</span>
            <h1>Identification Card</h1>
          </div>
          <span className="status-pill">
            {presentation.mode === 'PRESENTED' ? 'Presented ID' : 'Your ID'}
          </span>
        </header>
        <div className="identity-card__body">
          <div className="identity-card__portrait" aria-hidden="true">
            {document.first_name.charAt(0)}
            {document.last_name.charAt(0)}
          </div>
          <dl>
            <div>
              <dt>Full Name</dt>
              <dd>
                {document.first_name} {document.last_name}
              </dd>
            </div>
            <div>
              <dt>Date of Birth</dt>
              <dd>{document.date_of_birth}</dd>
            </div>
            <div>
              <dt>Document Number</dt>
              <dd>{document.document_number}</dd>
            </div>
            <div>
              <dt>Issued</dt>
              <dd>{document.issued_at}</dd>
            </div>
          </dl>
        </div>
        <footer>
          <span>Server-verified document</span>
          <button type="button" onClick={onClose}>
            Close
          </button>
        </footer>
      </section>
    </main>
  );
}
