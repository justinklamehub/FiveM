/** Browser entry point for the dedicated FiveM loading screen. */
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { Loadscreen } from './Loadscreen';
import './styles.css';

const root = document.getElementById('root');
if (!root) throw new Error('Loadscreen root element is missing.');
createRoot(root).render(
  <StrictMode>
    <Loadscreen />
  </StrictMode>,
);
