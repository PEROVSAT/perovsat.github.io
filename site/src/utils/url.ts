/** Join a path to the site base URL, handling missing slashes safely. */
export function withBase(path = ''): string {
  const base = import.meta.env.BASE_URL.endsWith('/')
    ? import.meta.env.BASE_URL
    : `${import.meta.env.BASE_URL}/`;

  if (!path) {
    return base;
  }

  return `${base}${path.replace(/^\//, '')}`;
}
