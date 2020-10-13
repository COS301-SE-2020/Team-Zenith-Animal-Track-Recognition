import { TestBed } from '@angular/core/testing';

import { AnimalStatisticsService } from './animal-statistics.service';

describe('AnimalStatisticsService', () => {
  let service: AnimalStatisticsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AnimalStatisticsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
