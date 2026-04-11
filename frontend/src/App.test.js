import { render, screen } from '@testing-library/react';
import App from './App';

test('renders DevOps Dashboard heading', () => {
  render(<App />);
  const linkElement = screen.getByText(/DevOps Project Dashboard/i);
  expect(linkElement).toBeInTheDocument();
});