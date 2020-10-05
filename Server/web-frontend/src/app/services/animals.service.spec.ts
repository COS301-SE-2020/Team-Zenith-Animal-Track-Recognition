import { TestBed } from '@angular/core/testing';

import { AnimalsService } from './animals.service';

describe('AnimalsService', () => {
  let service: AnimalsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AnimalsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
