import { TestBed } from '@angular/core/testing';

import { RangerStatisticsService } from './ranger-statistics.service';

describe('RangerStatisticsService', () => {
  let service: RangerStatisticsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(RangerStatisticsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
