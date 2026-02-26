import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';

interface VideoItem {
  title: string;
  channel: string;
  views: string;
  time: string;
  thumb: string;
  avatar: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  readonly categories = [
    'All',
    'Music',
    'Gaming',
    'Live',
    'Podcasts',
    'News',
    'Programming',
    'Cricket',
    'Movies',
    'Recently uploaded'
  ];

  readonly videos: VideoItem[] = [
    {
      title: 'Build a Modern Landing Page in 15 Minutes',
      channel: 'CodeQuick',
      views: '1.2M views',
      time: '2 days ago',
      thumb: 'https://picsum.photos/seed/v1/640/360',
      avatar: 'https://picsum.photos/seed/a1/80'
    },
    {
      title: 'Lofi Beats to Focus & Relax',
      channel: 'Night Vibes',
      views: '628K views',
      time: '1 week ago',
      thumb: 'https://picsum.photos/seed/v2/640/360',
      avatar: 'https://picsum.photos/seed/a2/80'
    },
    {
      title: 'India vs Australia Highlights | Full Match Recap',
      channel: 'Sports Arena',
      views: '3.8M views',
      time: '5 hours ago',
      thumb: 'https://picsum.photos/seed/v3/640/360',
      avatar: 'https://picsum.photos/seed/a3/80'
    },
    {
      title: 'React 2026 Crash Course for Beginners',
      channel: 'Dev Mentor',
      views: '942K views',
      time: '3 days ago',
      thumb: 'https://picsum.photos/seed/v4/640/360',
      avatar: 'https://picsum.photos/seed/a4/80'
    },
    {
      title: 'Street Food Tour in Delhi | 20 Must Try Spots',
      channel: 'Travel Bites',
      views: '420K views',
      time: '9 days ago',
      thumb: 'https://picsum.photos/seed/v5/640/360',
      avatar: 'https://picsum.photos/seed/a5/80'
    },
    {
      title: 'Top 10 AI Tools You Should Try Right Now',
      channel: 'Tech Talks',
      views: '2.1M views',
      time: '1 day ago',
      thumb: 'https://picsum.photos/seed/v6/640/360',
      avatar: 'https://picsum.photos/seed/a6/80'
    }
  ];
}
