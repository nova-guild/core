import http from 'k6/http';
import { check } from 'k6';

export const options = {
  stages: [
    { duration: '10s', target: 200 },
    { duration: '30s', target: 1000 },
    { duration: '10s', target: 0 },
  ],
};

export default function () {
  const params = {
    headers: { 'Connection': 'keep-alive' },
  };

  const homeRes = http.get('http://host.docker.internal:8080/', params);
  check(homeRes, { 'static_ok': (r) => r.status === 200 });
}