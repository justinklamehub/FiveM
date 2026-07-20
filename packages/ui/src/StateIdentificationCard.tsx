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
        <span className="identity-card__edge" aria-hidden="true">
          SAN ANDREAS
        </span>
        <span className="identity-card__watermark" aria-hidden="true">
          SA
        </span>
        <header className="identity-card__header">
          <div className="identity-card__seal">SA</div>
          <div>
            <span className="identity-card__authority">State of San Andreas</span>
            <h1>Identification Card</h1>
            <small>Department of Motor Vehicles</small>
          </div>
          <span className="identity-card__status">
            {presentation.mode === 'PRESENTED' ? 'Presented ID' : 'Valid ID'}
          </span>
        </header>
        <div className="identity-card__body">
          <div className="identity-card__portrait" aria-hidden="true">
            <span>
              {document.first_name.charAt(0)}
              {document.last_name.charAt(0)}
            </span>
            <small>Photo</small>
          </div>
          <dl>
            <div className="identity-card__name">
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
              <dt>ID Number</dt>
              <dd>{document.document_number}</dd>
            </div>
            <div>
              <dt>Issued</dt>
              <dd>{document.issued_at}</dd>
            </div>
          </dl>
        </div>
        <footer>
          <div>
            <strong>Server Verified</strong>
            <span>Official identity record</span>
          </div>
          <button type="button" onClick={onClose}>
            Close
          </button>
        </footer>
      </section>
    </main>
  );
}
