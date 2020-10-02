import { TestBed } from '@angular/core/testing';

import { TrackViewNavigationService } from './track-view-navigation.service';

describe('TrackViewNavigationService', () => {
  let service: TrackViewNavigationService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TrackViewNavigationService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
